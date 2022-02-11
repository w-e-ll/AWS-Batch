# AWS DPBatch Module
![https://www.terraform.io/](https://img.shields.io/badge/terraform-v0.12.24-purple)


This module helps to create an [AWS Batch stack](https://docs.aws.amazon.com/batch/latest/userguide/what-is-batch.html) within VPC. For more details about creating AWS Batch stacks, please see:
* [Terraform batch_compute_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_compute_environment)
* [Terraform batch_job_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_definition)
* [Terraform batch_job_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_queue)

## Standard architecture
A job definition specifies how jobs are to be run—for example, which Docker image to use for your job, how many vCPUs and how much memory is required, the IAM role to be used, and more.

Jobs are submitted to job queues where they reside until they can be scheduled to run on Amazon EC2 instances within a compute environment. An AWS account can have multiple job queues, each with varying priority. This gives you the ability to closely align the consumption of compute resources with your organizational requirements.

Compute environments provision and manage your EC2 instances and other compute resources that are used to run your AWS Batch jobs. Job queues are mapped to one more compute environments and a given environment can also be mapped to one or more job queues. This many-to-many relationship is defined by the compute environment order and job queue priority properties.

The following diagram shows a general overview of how the AWS Batch resources interact.

![https://aws.amazon.com/blogs/compute/using-aws-cloudformation-to-create-and-manage-aws-batch-resources/](https://d2908q01vomqb2.cloudfront.net/1b6453892473a467d07372d45eb05abc2031647a/2018/04/23/AWSBatchresoucreinteract-diagram.png)

> **Ref:**
> [Using AWS CloudFormation to Create and Manage AWS Batch Resources](https://d2908q01vomqb2.cloudfront.net/1b6453892473a467d07372d45eb05abc2031647a/2018/04/23/AWSBatchresoucreinteract-diagram.png)

## Requirements
|Name|Version|
|---|---|
|terraform | `~> 0.12.24`|
|aws| `>= 2.27.0`|
|alks| `~> 1.3.0`|

* VPC (*default*) should be present.
* Docker image should be present.

## Prerequisites
* Install
    * Aws cli
        * [pip install awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)
    * JQ library
        * https://stedolan.github.io/jq/
    * Tfswitch installs terraform and helps to jump between different terraform version
        * brew install warrensbox/tap/tfswitch
    * ALKS Terraform Plugin
        * Below are installation steps on Mac
            * curl -O https://github.com/Cox-Automotive/terraform-provider-alks/releases/download/1.3.1/terraform-provider-alks-darwin-amd64.tar.gz
            * tar xvzf terraform-provider-alks-darwin-amd64.tar.gz
            * mkdir ~/.terraform.d/plugins
            * mv terraform-provider-alks_v1.3.1 ~/.terraform.d/plugins/
* Declare some environment variables as follows:
    * AWS variables can be found at https://alks.coxautoinc.com/
        ```
        - AWS_ACCESS_KEY_ID
        - AWS_SECRET_ACCESS_KEY
        - AWS_DEFAULT_REGION
        - AWS_SESSION_TOKEN
        - AWS_REGION
        ```

## Usage

#### Get HashiCorp Terraform and Terraform AWS Provider
* [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
* [https://github.com/terraform-providers/terraform-provider-aws](https://github.com/terraform-providers/terraform-provider-aws)

```hcl-terrarform
provider "aws" {
  version = ">= 2.27.0"
  region  = "us-east-1"
}
```
#### Instance the module from your Terraform code:

```hcl-terraform
module "batch" {

  # Common
  source                     = "../service"
  region                     = var.region

  # Compute environment
  ce_maxvcpus                = local.ce_maxvcpus
  ce_minvcpus                = local.ce_minvcpus
  ce_desired_vcpus           = local.ce_desired_vcpus

  # Pipeline Job Queues
  job_queue_priority         = local.job_queue_priority
  CV_job_queue_name          = local.CV_job_queue_name
  NB_job_queue_name          = local.NB_job_queue_name
  job_queue_state            = local.job_queue_state

  # PDBatchProcessorChromeVeh job definition
  CV_job_def_name            = local.CV_job_def_name
  CV_container_image         = local.CV_container_image
  CV_memory                  = local.CV_memory
  CV_vcpus                   = local.CV_vcpus
  CV_job_command             = local.CV_job_command

  # NightlyBatchScheduler job definition
  NB_job_def_name            = local.NB_job_def_name
  NB_container_image         = local.NB_container_image
  NB_container_memory        = local.NB_container_memory
  NB_container_instance_type = local.NB_container_instance_type
  NB_container_job_role_arn  = local.NB_container_job_role_arn
  NB_lambda_function_name    = local.NB_lambda_function_name
  NB_endpoint_url            = local.NB_endpoint_url
  NB_main_node               = local.NB_main_node
  NB_num_nodes               = local.NB_num_nodes
  NB_service_name            = local.NB_service_name
  NB_target_nodes            = local.NB_target_nodes
  NB_vcpus                   = local.NB_vcpus

  # Job Scheduler
  schedule_expression        = local.schedule_expression

  # ChromeVehicle Job Scheduler
  CV_scheduler_name          = local.CV_scheduler_name

  # NightlyBatchScheduler Job Scheduler
  NB_scheduler_name          = local.NB_scheduler_name

  #Security Group name
  security_group_name        = local.security_group_name
}

```

## Single Node Job definition JSON template (Example)
```json
{
    "command": ["ls", "-la"],
    "image": "busybox",
    "memory": 1024,
    "vcpus": 1,
    "volumes": [
      {
        "host": {
          "sourcePath": "/tmp"
        },
        "name": "tmp"
      }
    ],
    "environment": [
        {"name": "VARNAME", "value": "VARVAL"}
    ],
    "mountPoints": [
        {
          "sourceVolume": "tmp",
          "containerPath": "/tmp",
          "readOnly": false
        }
    ],
    "ulimits": [
      {
        "hardLimit": 1024,
        "name": "nofile",
        "softLimit": 1024
      }
    ]
}
```

## Multi-node Job definition JSON template (Example)
```json
{
  "jobDefinitionName": "test-job",
  "type": "multinode",
  "parameters": {},
  "timeout": {"attemptDurationSeconds": 480},
  "nodeProperties": {
    "numNodes": 4,
    "mainNode": 0,
    "nodeRangeProperties": [
      {
        "targetNodes": "0:3",
        "container": {
          "image": "test-account.dkr.ecr.us-east-1.amazonaws.com/test-image:latest",
          "vcpus": 1,
          "memory": 2048,
          "command": [],
          "jobRoleArn": "arn:aws:iam::test-account:role/ecsTaskExecutionRole",
          "ulimits": [],
          "instanceType": "p3.2xlarge"
        }
      }
    ]
  }
}
```

## Deployment Process
### Manual Deployment & Teardown Flow
* For manual deployments project must be run from a specific folder - "aws_batch" during launch:
    * Init
        * Init aws-pdbatch 
    * Plan
        * Plan aws-pdbatch
    * Launch
        * Deploy aws-pdbatch
    * Teardown
        * Destroy aws-pdbatch

### Manual Deployment Commands
* There are 4 deployment commands for all projects: Initialize, Plan, Apply, & Destroy
    * Initialize ECS project terraform workspace
        * bash manage.sh init <AWS_REGION> <DEPLOY_ENVIRONMENT> <PROJECT_DIR>
        * Example: `bash manage.sh init us-east-1 lab aws_batch/aws-pdbatch`
    * Verify resources terraform will create/modify/destroy in the current workspace
        * bash manage.sh plan <AWS_REGION> <DEPLOY_ENVIRONMENT> <PROJECT_DIR> <CI_SUFFIX>
        * Example: `bash manage.sh plan us-east-1 lab aws_batch/aws-pdbatch`
    * Apply all resource changes to the current workspace and update terraform state in S3
        * bash manage.sh apply <AWS_REGION> <DEPLOY_ENVIRONMENT> <PROJECT_DIR> <CI_SUFFIX>
        * Example: `bash manage.sh apply us-east-1 lab aws_batch/aws-pdbatch`
    * Destroy all resources created by current workspace and update terraform state in S3
        * bash manage.sh destroy <AWS_REGION> <DEPLOY_ENVIRONMENT> <PROJECT_DIR> <CI_SUFFIX>
        * Example: `bash manage.sh destroy us-east-1 lab aws_batch/aws-pdbatch`

## Current status
ComputeEnvironment: 
- ECS Cluster 
- "PDBatch-CoEn"
- EC2 type 
- "MANAGED" 

CE Scaling: 
- min vCPU=1 
- max vCPU=10 
- desired vCPU=1

Scheduler:
- ChromeVehicle-job-onsched runs PDBatchProcessorChromeVeh Job every 10 minutes.
- NightlyBatch-job-onsched runs NightlyBatchScheduler Job every 10 minutes.

PipelineQueue:
- ChromeVehiclePipelineQueue is for PDBatchProcessorChromeVeh Job.
- NightlyBatchPipelineQueue is for NightlyBatchScheduler Job.

Job Definition:
- ChromeVehicle Job is single node
- NightlyBatch Job is multi-node

All Jobs will terminate after 8 minutes of execution, startingAt RUNNING state.

Right now the project is configured with testing data, test containers. Job will end in a Successful state.

## ToDo
- multi-node Job process Lock mechanism
- authentication definition to pull docker image from artifactory
- run ChromeVehicle and NightlyBatch containers and test environment
- add logging to container
- monitoring (New Relic?)
- describe DEP document
- describe README.MD

## Authors
Module managed by [Valentyn Sheboldaiev](Valentyn Sheboldaiev)

