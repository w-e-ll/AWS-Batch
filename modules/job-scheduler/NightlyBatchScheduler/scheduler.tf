resource "aws_cloudwatch_event_rule" "NightlyBatchScheduler" {
  name                = var.job_scheduler_name
  description         = var.event_rules_description
  is_enabled          = var.event_rules_is_enabled
  event_bus_name      = var.event_rules_bus_name
  schedule_expression = var.schedule_expression
  role_arn            = var.event_rules_role
}

resource "aws_cloudwatch_event_target" "NightlyBatch" {
  target_id           = var.target_id
  rule                = aws_cloudwatch_event_rule.NightlyBatchScheduler.name
  arn                 = var.job_queue_arn
  role_arn            = aws_iam_role.service_role.arn

  batch_target {
    job_name          = var.NB_job_def_name
    job_definition    = var.NB_job_arn
  }
}