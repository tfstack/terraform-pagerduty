variable "name" {
  description = "Name of the PagerDuty team."
  type        = string
}

variable "description" {
  description = "Description of the PagerDuty team."
  type        = string
  default     = null
}

variable "default_role" {
  description = "Default team role assigned to users who are not team members (observer, responder, manager, none)."
  type        = string
  default     = null
}

variable "parent" {
  description = "Optional parent team ID for nested teams."
  type        = string
  default     = null
}
