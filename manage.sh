#!/bin/bash

set -e

ACTION=$1
REGION=$2
DEPLOY_ENV=$3
PROJECT_DIR=$4

function verify_prerequisites() {
    command -v aws >/dev/null 2>&1 || { echo "Please install aws cli, Install it: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html"; exit 1; }
    command -v jq >/dev/null 2>&1 || { echo  "Please install jq, Install it: https://stedolan.github.io/jq/"; exit 1; }
}

function get_terraform_state_bucket() {
    local bucket_name
    bucket_name="$(get_account_alias)"-terraform-state-"$REGION"
    if aws s3api get-bucket-location --bucket "$bucket_name" --region "$REGION" 2>&1 | grep -q 'NoSuchBucket'; then
        echo "Creating S3 bucket $bucket_name"
        aws s3api create-bucket --bucket "$bucket_name" --region "$REGION"
    fi
    echo "$bucket_name"
}

function get_workspace_name() {
    echo "$DEPLOY_ENV"-"$REGION"
}

function get_account_alias() {
    echo "$(aws iam list-account-aliases --output json | jq -r '.AccountAliases[0]')"
}

function get_terraform_state_name() {
    key=$(echo "$PROJECT_DIR" | awk -F"tests/" '{print $2}')
    if [ -z "$key" ];then
      echo "$key"
    else echo "$key"
    fi
}

function initialize_terraform() {
    local aws_s3_bucket_name=$1
    terraform_state=$(get_terraform_state_name)
    if [ -z "$terraform_state" ];then
      terraform init -get=true -input=false -backend-config=bucket="$aws_s3_bucket_name"
    else
      echo Terraform state filename = "$terraform_state"
      terraform init -get=true -input=false -backend-config=bucket="$aws_s3_bucket_name" -backend-config=key="$terraform_state"
    fi
}

function create_or_select_terraform_workspace() {
    pushd "$PROJECT_DIR"
    local terraform_state_bucket
    local workspace_name
    terraform_state_bucket=$(get_terraform_state_bucket)
    workspace_name=$(get_workspace_name)
    echo "[INFO] Terraform bucket = $terraform_state_bucket"
    initialize_terraform "$terraform_state_bucket"
    terraform workspace new "$workspace_name" || terraform workspace select "$workspace_name"
    popd
}

function terraform_plan() {
    pushd "$PROJECT_DIR"
    terraform plan -input=false -var region="$REGION" -var environment="$DEPLOY_ENV" -var name="$NAME"
    popd
}

function terraform_apply() {
    pushd "$PROJECT_DIR"
    terraform apply -auto-approve -input=false -var region="$REGION" -var environment="$DEPLOY_ENV" -var name="$NAME"
    popd
}

function terraform_destroy() {
    pushd "$PROJECT_DIR"
    terraform destroy -auto-approve -input=false -var region="$REGION" -var environment="$DEPLOY_ENV" -var name="$NAME"
    rm -rf .terraform
    popd
}

function delete_terraform_state() {
    workspace_name=$(get_workspace_name)
    terraform_state_bucket=$(get_terraform_state_bucket)
    terraform_state=$(get_terraform_state_name)
    if [ -n "$terraform_state" ];then
      echo "Removing all versions for $workspace_name/$terraform_state from $terraform_state_bucket"
      versions=$(aws s3api list-object-versions --bucket "$terraform_state_bucket" --prefix "env:/${workspace_name}/${terraform_state}" |jq '.Versions')
      for version in $(echo "${versions}" | jq -r '.[]| @base64'); do
          versionId=$(echo "$version" | base64 --decode | jq -r .VersionId )
          aws s3api delete-object --bucket "$terraform_state_bucket" --key "env:/${workspace_name}/${terraform_state}" --version-id "$versionId"
      done
    fi
}


if [ "$ACTION" = "init" ]; then
    verify_prerequisites
    create_or_select_terraform_workspace
elif [ "$ACTION" = "plan" ]; then
    terraform_plan
elif [ "$ACTION" = "apply" ]; then
    terraform_apply
elif [ "$ACTION" = "destroy" ]; then
    terraform_destroy
    delete_terraform_state
elif [ "$ACTION" = "deploy" ]; then
    verify_prerequisites
    create_or_select_terraform_workspace
    terraform_plan
    terraform_apply
fi
