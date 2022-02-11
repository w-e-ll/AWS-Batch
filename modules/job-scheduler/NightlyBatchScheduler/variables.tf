######################################## Common ########################################################################

variable "NB_job_arn" {
  description = "NightlyBatch job definition ARN"
  type        = string
  default     = null
}

variable "NB_job_def_name" {
  description = "NightlyBatch job definition name"
  type        = string
  default     = null
}

variable "job_scheduler_name" {
  description = "The name of the job scheduler."
  type        = string
}

variable "job_tag" {
  description = "Job Tag"
  type        = string
  default     = "NB3"
}

variable "target_id" {
  description = "NB Target id"
  type        = string
  default     = "run"
}

##################################### IAM for EventBridge ##############################################################

variable "event_policy_name" {
  description = "Name of the policy (_var.name will be appended)."
  type        = string
  default     = "AWS_Events_Invoke_Batch_Job_Queue"
}

variable "event_policy_description" {
  description = "Description of the IAM policy (var.name will be appended)."
  type        = string
  default     = "Service Role for EventBridge / Batch Job"
}

variable "event_role_name" {
  description = "Name of the role (_var.name will be appended)."
  type        = string
  default     = "AWS_Events_Invoke_Batch_Job_Queue"
}

variable "event_role_description" {
  description = "Description of the IAM role (var.name will be appended)."
  type        = string
  default     = "Service Role for EventBridge / Batch Job"
}

variable "event_role_path" {
  description = "Path in which to create the policy."
  type        = string
  default     = "/service-role/"
}

###################################### EventBridge Rules ###############################################################

variable "job_queue_arn" {
  description = "NightlyBatch Batch Job Queue ARN"
  type        = string
}

variable "event_rule_target_id" {
  description = "The unique target assignment ID. Will be prefixed with var.prefix and sufixed by -onsched/onevent."
  type        = string
  default     = "NBBJ1"
}

variable "event_rules_description" {
  description = "The description of the rule."
  type        = string
  default     = "Run batch job based on event or schedule"
}

variable "event_rules_is_enabled" {
  description = "Whether or not to enable EventBridge Rule"
  type        = bool
  default     = true
}

variable "event_rules_bus_name" {
  description = "The event bus to associate with this rule. If you omit this, the default event bus is used."
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule_expression or event_pattern is required. Can only be used on the default event bus."
  type        = string
  default     = null
}

variable "event_rules_role" {
  description = "The Amazon Resource Name (ARN) associated with the role that is used for target invocation."
  type        = string
  default     = null
}
