data "aws_secretsmanager_secret" "creds" {
  name = "ECS-Artifactory-Credentials"
}

resource "alks_iamrole" "ecs_execution_role" {
  name                     = "AWS-PDBatch-lab-us-east-1-ecs-exec-role"
  type                     = "Amazon EC2 Container Service Task Role"
  include_default_policies = true
}

data "aws_iam_policy_document" "ecs_execution_role_policy_document" {
  statement {
    sid    = "EcrAuth"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "AWS-PDBatch-lab-us-east-1-ecs-exec-role-policy"
  policy = data.aws_iam_policy_document.ecs_execution_role_policy_document.json
  role   = alks_iamrole.ecs_execution_role.id
}

resource "aws_batch_job_definition" "ChromeVehicle" {
  name                 = var.job_definition_name
  type                 = "container"
  container_properties = <<CONTAINER_PROPERTIES
{
    "command": ["ls", "-la"],
    "image": "dtfni-docker.artifactory.coxautoinc.com/drs/paymentdriver/development/batchprocessor:0.0.1-abc",
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
        {"name": "env", "value": "lab"}
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
    ],
    "portMappings"  : [
      {
        "containerPort" : 80,
        "hostPort"      : 0,
        "protocol"      : "tcp"
      }
    ],
    "timeout": [
      {
        "attemptDurationSeconds": 480
      }
    ]
}
CONTAINER_PROPERTIES
}