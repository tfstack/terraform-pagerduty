variable "name" {
  description = "Name of the escalation policy."
  type        = string
}

variable "rules" {
  description = "Escalation rules defining notification order. user_reference targets must use PagerDuty user IDs."
  type = list(object({
    escalation_delay_in_minutes = number
    targets = list(object({
      type = string
      id   = string
    }))
  }))
}

variable "description" {
  description = "Description of the escalation policy."
  type        = string
  default     = null
}

variable "num_loops" {
  description = "Number of times the escalation policy repeats after reaching the end."
  type        = number
  default     = 1
}

variable "team_id" {
  description = "Optional PagerDuty team ID to associate with the escalation policy."
  type        = string
  default     = null
}
