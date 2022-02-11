// Job queue
output "job_queue_arn" {
  description = "The Job queue ARN."
  value       = aws_batch_job_queue.job-queue.arn
}

output "job_queue_state" {
  description = "Job queue state"
  value       = aws_batch_job_queue.job-queue.state
}
