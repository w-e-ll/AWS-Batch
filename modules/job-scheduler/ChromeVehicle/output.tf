output "ChromeVehicleJobScheduler_arn" {
  value = aws_cloudwatch_event_rule.ChromeVehicleScheduler.arn
}

output "ChromeVehicle_target_schedule_arn" {
  value = aws_cloudwatch_event_target.ChromeVehicle.arn
}
