output "job_definition_name" {
  description = "The ChromeVehicle Job definition name."
  value = aws_batch_job_definition.ChromeVehicle.name
}

output "job_definition_arn" {
  description = "The ChromeVehicle Job definition ARN."
  value       = aws_batch_job_definition.ChromeVehicle.arn
}

output "job_definition_container_properties" {
  description = "The ChromeVehicle Job definition container properties."
  value       = aws_batch_job_definition.ChromeVehicle.container_properties
}