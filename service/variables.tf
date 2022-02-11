data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "creds" {
  name = "ECS-Artifactory-Credentials"
}

#################################### General Variables #################################################################

variable "region" {
  description = "Project name for tags and resource naming"
  type        = string
  default     = null
}

#################################### Compute Environment ###############################################################

variable "ce_allocation_strategy" {
  description = "The allocation strategy to use for the compute resource in case not enough instances of the best fitting instance type can be allocated. Valid items are BEST_FIT_PROGRESSIVE, SPOT_CAPACITY_OPTIMIZED or BEST_FIT."
  type        = string
  default     = "BEST_FIT"
}

variable "ce_instance_type" {
  description = "What instances compute environment will use"
  type        = list(string)
  default     = ["m5.large", "m5a.4xlarge"]
}

variable "ce_maxvcpus" {
  description = "Max allowed Vcpus to be spun up by compute environment"
  type        = number
  default     = 10
}

variable "ce_minvcpus" {
  description = "Min allowed Vcpus to be spun up by compute environment"
  type        = number
  default     = 1
}

variable "ce_desired_vcpus" {
  description = "Desired_vcpus allowed Vcpus to be spun up by compute environment"
  default     = null
  type        = number
}

variable "ce_name" {
  type        = string
  default     = "PDBatch-CoEn"
}

variable "ce_management_type" {
  description = "Compute environment management type"
  type        = string
  default     = "MANAGED"
}

variable "ce_type" {
  description = "Compute environment type"
  type        = string
  default     = "EC2"
}

#################################### Job Queue #########################################################################

variable "CV_job_queue_name" {
  description = "The name of the ChromeVehicle Job Queue"
  default     = "ChromeVehiclePipelineQueue"
  type        = string
}

variable "NB_job_queue_name" {
  description = "The name of the NightlyBatch Job Queue"
  default     = "NightlyBatchPipelineQueue"
  type        = string
}

variable "job_queue_priority" {
  description = "The job queue priority"
  type        = number
  default     = 1
}

variable "job_queue_state" {
  description = "The job queue state"
  default     = "ENABLED"
  type        = string
}

#################################### NightlyBatchScheduler Job Def #####################################################

variable "NB_job_def_name" {
  description = "The name of the NightlyBatch job definition"
  default     = "NightlyBatchScheduler"
  type        = string
}

variable "NB_container_image" {
  description = "NightlyBatch container image"
  default     = "busybox"
  type        = string
}

variable "NB_container_memory" {
  description = "NightlyBatch container memory"
  type        = number
  default     = 1024
}

variable "NB_container_command" {
  description = "The name of the NightlyBatch job definition"
  type        = string
  default     = null
}

variable "NB_container_instance_type" {
  description = "NightlyBatch container instance type"
  default     = "m5.large"
  type        = string
}

variable "NB_container_job_role_arn" {
  description = "NightlyBatch container job role arn"
  type        = string
}

variable "NB_lambda_function_name" {
  type        = string
  description = "NightlyBatch Lambda function name"
  default     = "NightlyBatch-job-definition"
}

variable "NB_endpoint_url" {
  type        = string
  description = "NightlyBatch endpoint url"
  default     = "https://batch.us-east-1.amazonaws.com"
}

variable "NB_main_node" {
  description = "NightlyBatch main node"
  type        = number
  default     = 0
}

variable "NB_num_nodes" {
  description = "NightlyBatch num nodes"
  type        = number
  default     = 4
}

variable "NB_service_name" {
  description = "NightlyBatch service name"
  default     = "batch"
}

variable "NB_target_nodes" {
  description = "NightlyBatch target nodes"
  type        = string
  default     = "0:3"
}

variable "NB_vcpus" {
  description = "NightlyBatch vcpus"
  type        = number
  default     = 1
}

#################################### PDBatchProcessorChromeVeh Job Def #################################################

variable "CV_vcpus" {
  description = "ChromeVehicle VCPUs required by the job definition"
  type        = number
  default     = 1
}

variable "CV_memory" {
  description = "ChromeVehicle job definition memory"
  type        = number
  default     = 1024
}

variable "CV_job_command" {
  description = "ChromeVehicle Job definition command"
  default     = ["ls", "-l"]
  type        = list(string)
}

variable "CV_job_def_name" {
  description = "The name of the ChromeVehicle job definition"
  default     = "PDBatchProcessorChromeVeh"
  type        = string
}

variable "CV_container_image" {
  description = "The name of the ChromeVehicle docker repo name"
  default     = "busybox"
  type        = string
}

variable "CV_container_properties" {
  description = "Container properties of the PDBatch"
  default     = null
}

#################################### Job Scheduler #####################################################################

variable "schedule_expression" {
  description = "Job scheduler schedule expression"
  type        = string
  default     = "rate(10 minutes)"
}

variable "CV_scheduler_name" {
  description = "Name of the ChromeVehicle job scheduler"
  type        = string
  default     = "ChromeVehicle-job-onsched"
}

variable "NB_scheduler_name" {
  description = "Name of the NightlyBatch job scheduler"
  type        = string
  default     = "NightlyBatch-job-onsched"
}

#################################### Network variables #################################################################

variable "private_subnets" {
  description = "List of subnets that are tied to services which are not exposed to outside world"
  type        = list(string)
  default     = null
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "batch_sg"
}

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "lab"
}

variable "ecs_ami_name" {
  description = "name of the ecs optimised ami"
  type        = string
  default     = "Windows_Server-2019-English-Full-ECS_Optimized*"
}

variable "instance_type" {
  description = "type of ec2 instance that need to be provisioned"
  type        = string
  default     = "m5.large"
}

variable "tags" {
  description = "Tags that need to be attached to resources that are created"
  type        = list(map(string))
  default     = null
}

//variable "artifactory_credentials" {
//  description = "The ARN of the artifactory credentials"
//  type        = string
//  default     = null
//}

