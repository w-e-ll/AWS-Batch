data "archive_file" "NightlyBatch-job-definition" {
  type                    = "zip"
  source_dir              = "${path.module}/lambda/"
  output_path             = "${path.module}/lambda.zip"
}

data "aws_lambda_invocation" "NightlyBatch-lambda_local_invoker" {
  input                   = ""
  function_name           = var.lambda_function_name
  depends_on = [aws_lambda_function.NightlyBatch-job-definition]
}

### Terraform does not support MultiNode Job definition. Have to use lambda to create it. ###

resource "aws_lambda_function" "NightlyBatch-job-definition" {
  filename                = "${path.module}/lambda.zip"
  function_name           = var.lambda_function_name
  role                    = aws_iam_role.iam_for_lambda.arn
  handler                 = "job-definition.lambda_handler"
  source_code_hash        = data.archive_file.NightlyBatch-job-definition.output_base64sha256
  runtime                 = "python3.6"

  environment {
    variables = {
      region              = var.container_region
      service_name        = var.container_service_name
      endpoint_url        = var.container_endpoint_url
      image               = var.container_image
      vcpus               = var.container_vcpus
      memory              = var.container_memory
      command             = var.container_command
      num_nodes           = var.container_num_nodes
      main_node           = var.container_main_node
      target_nodes        = var.container_target_nodes
      instance_type       = var.container_instance_type
      job_role_arn        = var.container_job_role_arn
      job_definition_name = var.container_job_def_name
    }
  }
}
