locals {
  private_subnets               = module.vpc.private_subnets
  current_account               = data.aws_caller_identity.current.account_id
  artifactory_credentials       = data.aws_secretsmanager_secret.creds.arn
  default_tags = [
    {
      name  = "Application"
      value = "AWS-PDBatch"
    },
    {
      name  = "Environment"
      value = var.environment
    },
    {
      name  = "ClusterName"
      value = var.ce_name
    }
  ]

  ec2_configuration = [
    {
      name  = "image_type"
      value = "ECS_AL2"
    },
    {
      name  = "image_id_override"
      value = "ami-0524bad7192a3ff2a"
    },
    {
      name  = "ClusterName"
      value = var.ce_name
    }
  ]

  tags = var.tags == null ? local.default_tags : var.tags
}

module "vpc" {
  source                        = "../modules/vpc"
  get_vpc                       = var.private_subnets != null ? false : true
}

module "compute-environment" {
  source                        = "../modules/compute-environment"
  ce_name                       = var.ce_name
  ce_type                       = var.ce_type
  ce_management_type            = var.ce_management_type
  instance_type                 = var.ce_instance_type
  maxvcpus                      = var.ce_maxvcpus
  minvcpus                      = var.ce_minvcpus
  desired_vcpus                 = var.ce_desired_vcpus
  ce_security_groups            = [aws_security_group.batch_sg.id]
  ce_subnets                    = local.private_subnets
  ce_allocation_strategy        = var.ce_allocation_strategy

  ce_launch_template = [{
    launch_template_id      = module.launch_template.launch_template_id,
    launch_template_version = module.launch_template.launch_template_version,
  }]

}


module "launch_template" {
  source                 = "../modules/launch_template"
  ce_name                = var.ce_name
  environment            = var.environment
  ecs_service_sg_id      = aws_security_group.batch_sg.id
  instance_type          = var.instance_type
  ecs_instance_role_name = "${var.ce_name}-ecs-instance-role"
//  user_data              = local.userdata
  ecs_ami_name           = var.ecs_ami_name
  tags                   = local.tags
}

# job queue
module "ChromeVehiclePipelineQueue" {
  source                        = "../modules/job-queue"
  job_queue_name                = var.CV_job_queue_name
  job_queue_priority            = var.job_queue_priority
  compute_environment_list      = [var.ce_name]
  job_queue_state               = var.job_queue_state
  jq_depends_on                 = [module.compute-environment.compute_environment_name]
}

module "NightlyBatchPipelineQueue" {
  source                        = "../modules/job-queue"
  job_queue_name                = var.NB_job_queue_name
  job_queue_priority            = var.job_queue_priority
  compute_environment_list      = [var.ce_name]
  job_queue_state               = var.job_queue_state
  jq_depends_on                 = [module.compute-environment.compute_environment_name]
}

# PDBatchProcessorChromeVeh jd
module "ChromeVehicle-job-definition" {
  source                        = "../modules/job-definition/ChromeVehicle"
  job_definition_name           = var.CV_job_def_name
  command                       = var.CV_job_command
  container_image               = var.CV_container_image
  memory                        = var.CV_memory
  vcpus                         = var.CV_vcpus
  container_properties          = var.CV_container_properties
}

module "NightlyBatchScheduler-job-definition" {
  source                        = "../modules/job-definition/NightlyBatchScheduler"
  container_region              = var.region
  container_job_def_name        = var.NB_job_def_name
  container_image               = var.NB_container_image
  container_memory              = var.NB_container_memory
  container_command             = var.NB_container_command
  container_instance_type       = var.NB_container_instance_type
  container_job_role_arn        = var.NB_container_job_role_arn
  lambda_function_name          = var.NB_lambda_function_name
  container_endpoint_url        = var.NB_endpoint_url
  container_main_node           = var.NB_main_node
  container_num_nodes           = var.NB_num_nodes
  container_service_name        = var.NB_service_name
  container_target_nodes        = var.NB_target_nodes
  container_vcpus               = var.NB_vcpus
}

module "ChromeVehicleJobScheduler" {
  source                        = "../modules/job-scheduler/ChromeVehicle"
  job_scheduler_name            = var.CV_scheduler_name
  job_queue_arn                 = module.ChromeVehiclePipelineQueue.job_queue_arn
  CV_job_def_name               = var.CV_job_def_name
  CV_job_arn                    = module.ChromeVehicle-job-definition.job_definition_arn
  schedule_expression           = var.schedule_expression
}

module "NightlyBatchJobScheduler" {
  source                        = "../modules/job-scheduler/NightlyBatchScheduler"
  job_scheduler_name            = var.NB_scheduler_name
  job_queue_arn                 = module.NightlyBatchPipelineQueue.job_queue_arn
  NB_job_def_name               = var.NB_job_def_name
  NB_job_arn                    = "arn:aws:batch:${var.region}:${local.current_account}:job-definition/${var.NB_job_def_name}:1"
  schedule_expression           = var.schedule_expression
}


//locals {
//  userdata = <<EOF
//      <powershell>
//      [Environment]::SetEnvironmentVariable("ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE", "true", "Machine")
//      Initialize-ECSAgent -Cluster ${var.ce_name}-${var.environment} -EnableTaskIAMRole -LoggingDrivers '["json-file","awslogs"]'
//      </powershell>
//      <persist>true</persist>
//    EOF
//}
