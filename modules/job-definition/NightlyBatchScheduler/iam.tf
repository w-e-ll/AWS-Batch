resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.job_tag}-ecs-instance-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_s3" {
  role                = aws_iam_role.ecs_instance_role.name
  policy_arn          = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_ec2" {
  role                = aws_iam_role.ecs_instance_role.name
  policy_arn          = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name                = "${var.job_tag}_ecs_instance_profile"
  role                = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role" "aws_batch_service_role" {
  name                = "${var.job_tag}_iam_role"
  assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role                 = aws_iam_role.aws_batch_service_role.name
  policy_arn           = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role" "iam_for_lambda" {
  name                 = "iam-for-lambda-${var.job_tag}"
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role                  = aws_iam_role.iam_for_lambda.name
  policy_arn            = var.lambda_logs_policy_arn
}

resource "aws_iam_role_policy" "lambda_reg_job_def" {
  name                  = "Register-${var.job_tag}-Job-Definition"
  role                  = aws_iam_role.iam_for_lambda.id
  policy                = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["batch:RegisterJobDefinition", "batch:DeregisterJobDefinition"],
            "Resource": ["arn:aws:batch:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:job-definition/${var.container_job_def_name}"]
        },
        {
            "Effect": "Allow",
            "Action": ["iam:PassRole"],
            "Resource": ["*"]
        }
    ]
}
EOF
}
