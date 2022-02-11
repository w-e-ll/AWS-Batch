output "NightlyBatchJobScheduler_arn" {
  value = aws_cloudwatch_event_rule.NightlyBatchScheduler.arn
}

output "NightlyBatch_target_schedule_arn" {
  value = aws_cloudwatch_event_target.NightlyBatch.arn
}
