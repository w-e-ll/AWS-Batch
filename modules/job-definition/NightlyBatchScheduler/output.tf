output "result_entry" {
  value = jsondecode(data.aws_lambda_invocation.NightlyBatch-lambda_local_invoker.result)
}