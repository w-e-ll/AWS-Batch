output "compute_environment_name" {
  description = "The CE name."
  value       = aws_batch_compute_environment.compute-environment.compute_environment_name
}

output "compute_environment_state" {
  description = "The CE state."
  value       = aws_batch_compute_environment.compute-environment.state
}

output "compute_environment_arn" {
  description = "The CE arn."
  value       = aws_batch_compute_environment.compute-environment.arn
}

output "compute_environment_id" {
  description = "The CE id."
  value       = aws_batch_compute_environment.compute-environment.id
}