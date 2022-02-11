variable "ce_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "environment" {
  description = "Environment trying to deploy"
  type        = string
}

variable "ecs_service_sg_id" {
  description = "Security group id for ecs service"
  type        = string
}

variable "instance_type" {
  description = "type of ec2 instance that need to be provisioned"
  type        = string
}

variable "ecs_instance_role_name" {
  description = "The name attribute of the IAM instance profile to associate with launched instances."
  type        = string
}

//variable "user_data" {
//  description = "The user data to provide when launching the instance"
//  type        = any
//}

variable "ecs_ami_name" {
  description = "name of the ecs optimised ami"
  type        = string
}

variable "tags" {
  description = "Tags that need to be attached to resources that are created"
  type        = list(map(string))
}

locals {
  name_tag = [{
    name  = "Name"
    value = "${var.ce_name}-${var.environment}"
  }]
  tags = concat(var.tags, local.name_tag)
}
