data "aws_caller_identity" "current" {}

variable "job_tag" {
  description = "Tag of the ChromeVehicle"
  default     = "CV3"
  type        = string
}

variable "vcpus" {
  description = "ChromeVehicle VCPUs required by the job definition"
  type        = number
}

variable "memory" {
  description = "ChromeVehicle job definition memory"
  type        = number
}

variable "command" {
  description = "ChromeVehicle Job definition command"
  type        = list(string)
}

variable "container_image" {
  description = "ChromeVehicle Job definition image"
  type = string
}

variable "job_definition_name" {
  description = "The name of the ChromeVehicle job definition"
  type        = string
}

variable "container_properties" {
  description = "Container properties of the ChromeVehicle"
  default     = null
}
