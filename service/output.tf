output "ChromeVehiclePipelineQueue_arn" {
  value = module.ChromeVehiclePipelineQueue.job_queue_arn
}

output "NightlyBatchPipelineQueue_arn" {
  value = module.NightlyBatchPipelineQueue.job_queue_arn
}

output "compute_environment_name" {
  value = module.compute-environment.compute_environment_name
}

output "ChromeVehicle_job_definition_name" {
  value = module.ChromeVehicle-job-definition.job_definition_name
}

output "ChromeVehicle_job_definition_arn" {
  value = module.ChromeVehicle-job-definition.job_definition_arn
}

output "NightlyBatchJobScheduler_arn" {
  value = module.NightlyBatchJobScheduler.NightlyBatchJobScheduler_arn
}

output "ChromeVehicleJobScheduler_arn" {
  value = module.ChromeVehicleJobScheduler.ChromeVehicleJobScheduler_arn
}