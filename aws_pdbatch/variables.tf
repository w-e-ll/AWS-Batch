variable "environment" {
  description                = "Environment trying to deploy"
  type                       = string
}

variable "region" {
  description                = "AWS region"
  type                       = string
}

variable "name" {
  description                = "name"
  type                       = string
}

locals {
  name                       = "AWS-PDBatch"
  region                     = var.region

  # Compute Environment
  ce_name                    = "PDBatch-CoEn"
  ce_type                    = "EC2"
  ce_maxvcpus                = 10
  ce_minvcpus                = 1
  ce_desired_vcpus           = 1
  ce_management_type         = "MANAGED"
  ce_instance_type           = ["m5.large", "m5a.4xlarge"]

  # Pipeline Job Queues
  job_queue_priority         = 1
  job_queue_state            = "ENABLED"
  CV_job_queue_name          = "ChromeVehiclePipelineQueue"
  NB_job_queue_name          = "NightlyBatchPipelineQueue"

  # ChromeVehicle job definition
  CV_job_def_name            = "PDBatchProcessorChromeVeh"
  CV_container_image         = "dtfni-docker.artifactory.coxautoinc.com/drs/paymentdriver/development/batchprocessor:0.0.1-abc"
  CV_memory                  = 1024
  CV_vcpus                   = 1
  CV_job_command             = ["ls", "-la"]

  # NightlyBatchScheduler job definition
  NB_job_def_name            = "NightlyBatchSchedulerTest9"
  NB_container_image         = "dtfni-docker.artifactory.coxautoinc.com/drs/paymentdriver/development/batchprocessor:0.0.1-abc"
  NB_container_memory        = 1024
  NB_vcpus                   = 1
//  NB_container_command         = ["ls", "-la"]
  NB_container_instance_type = "m5.large"
  NB_container_job_role_arn  = "arn:aws:iam::607694952559:role/ecsTaskExecutionRole"
  NB_lambda_function_name    = "NightlyBatch-job-definition"
  NB_endpoint_url            = "https://batch.us-east-1.amazonaws.com"
  NB_main_node               = 0
  NB_num_nodes               = 4
  NB_target_nodes            = "0:3"
  NB_service_name            = "batch"

  # Job Scheduler
  schedule_expression        = "rate(2 minutes)"

  # ChromeVehicle Job Scheduler
  CV_scheduler_name          = "ChromeVehicle-job-onsched"

  # NightlyBatchScheduler Job Scheduler
  NB_scheduler_name          = "NightlyBatch-job-onsched"

  # Security Group name
  security_group_name        = "batch_sg"

  tags = [
    {
      name  = "Application"
      value = local.name
    },
    {
      name  = "Environment"
      value = var.environment
    },
    {
      name  = "Email"
      value = "valentyn.sheboldaiev@coxautoinc.com"
    },
    {
      name  = "Team"
      value = "PayMate"
    }
  ]
}