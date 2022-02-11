variable "ce_management_type" {
  description = "Compute environment management type"
  type        = string
}

variable "ce_type" {
  description = "Compute environment type"
  type        = string
}

variable "ce_name" {
  description = "The name of the compute environment"
  type        = string
}

variable "instance_type" {
  description = "What instances compute environment will use"
  type        = list(string)
}

variable "maxvcpus" {
  description = "Max allowed Vcpus to be spun up by compute environment"
}

variable "minvcpus" {
  description = "Min allowed Vcpus to be spun up by compute environment"
}

variable "desired_vcpus" {
  description = "Desired_vcpus allowed Vcpus to be spun up by compute environment"
}

variable "ce_security_groups" {
  description = "Compute environment security groups"
  type        = list(string)
}

variable "ce_subnets" {
  description = "Compute environment subnets"
  type        = list(string)
}

variable "launch_template" {
  type        = map(string)
  description = "The launch template to use for your compute resource"
  default     = {}
}

variable "ce_launch_template" {
  description = "Launch template configuration for compute environment format: list(object({ launch_template_id = string, version = optional(number) }))"
  type = list(any)
  # Can not be null, because it's used in a for_each
  default = []
}

variable "ce_allocation_strategy" {
  description = "The allocation strategy to use for the compute resource in case not enough instances of the best fitting instance type can be allocated. Valid items are BEST_FIT_PROGRESSIVE, SPOT_CAPACITY_OPTIMIZED or BEST_FIT."
  type        = string
}
