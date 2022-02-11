module "batch" {

  # Common
  source                     = "../service"
  region                     = var.region

  # Compute environment
  ce_maxvcpus                = local.ce_maxvcpus
  ce_minvcpus                = local.ce_minvcpus
  ce_desired_vcpus           = local.ce_desired_vcpus

  # Pipeline Job Queues
  job_queue_priority         = local.job_queue_priority
  CV_job_queue_name          = local.CV_job_queue_name
  NB_job_queue_name          = local.NB_job_queue_name
  job_queue_state            = local.job_queue_state

  # PDBatchProcessorChromeVeh job definition
  CV_job_def_name            = local.CV_job_def_name
  CV_container_image         = local.CV_container_image
  CV_memory                  = local.CV_memory
  CV_vcpus                   = local.CV_vcpus
  CV_job_command             = local.CV_job_command

  # NightlyBatchScheduler job definition
  NB_job_def_name            = local.NB_job_def_name
  NB_container_image         = local.NB_container_image
  NB_container_memory        = local.NB_container_memory
// NB_container_command      = local.NB_container_command
  NB_container_instance_type = local.NB_container_instance_type
  NB_container_job_role_arn  = local.NB_container_job_role_arn
  NB_lambda_function_name    = local.NB_lambda_function_name
  NB_endpoint_url            = local.NB_endpoint_url
  NB_main_node               = local.NB_main_node
  NB_num_nodes               = local.NB_num_nodes
  NB_service_name            = local.NB_service_name
  NB_target_nodes            = local.NB_target_nodes
  NB_vcpus                   = local.NB_vcpus

  # Job Scheduler
  schedule_expression        = local.schedule_expression

  # ChromeVehicle Job Scheduler
  CV_scheduler_name          = local.CV_scheduler_name

  # NightlyBatchScheduler Job Scheduler
  NB_scheduler_name          = local.NB_scheduler_name

  #Security Group name
  security_group_name        = local.security_group_name
}
