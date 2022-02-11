variable "job_queue_name" {
  description = "The name of the job queue"
  type        = string
}

variable "compute_environment_list" {
  description = "The list of compute environments to attach"
  type        = list(string)
}

variable "jq_depends_on" {
  type        = any
  default     = null
}

variable "job_queue_state" {
  description = "State of the created Job Queue."
  type        = string
}

variable "job_queue_priority" {
  description = "Priority of the created Job Queue."
  type        = string
}