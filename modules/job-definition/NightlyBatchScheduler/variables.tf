data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

variable "container_job_def_name" {
  description = "The name of the NightlyBatch job definition"
  type        = string
}

variable "job_tag" {
  description = "Tag of the NightlyBatch"
  default     = "NB3"
  type        = string
}

variable "container_region" {
  description = "The name of the region"
  type        = string
}

variable "container_service_name" {
  description = "The name of the service_name"
  type        = string
}

variable "container_endpoint_url" {
  description = "The name of the endpoint_url"
  type        = string
}

variable "container_num_nodes" {
  description = "The name of the num_nodes"
  type        = number
}

variable "container_main_node" {
  description = "The name of the main_node"
  type        = number
}

variable "container_target_nodes" {
  description = "The name of the target_nodes"
  type        = string
}

variable "container_image" {
  description = "The name of the container_image"
  type        = string
}

variable "container_memory" {
  description = "The name of the container_memory"
  type        = number
}

variable "container_vcpus" {
  description = "The name of the container_vcpus"
  type        = number
}

variable "container_command" {
  type        = string
  description = "The name of the container_command"
}

variable "container_instance_type" {
  description = "The name of the container_instance_type"
  type        = string
}

variable "container_job_role_arn" {
  description = "The name of the container_job_role_arn"
  type        = string
}

variable "lambda_logs_policy_arn" {
  type        = string
  description = "Lambda logs Identity Provider ARN"
  default     = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name"
}


