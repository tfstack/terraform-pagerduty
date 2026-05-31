variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "escalation_policy_id" {
  type = string
}

variable "alert_creation" {
  type    = string
  default = "create_alerts_and_incidents"
}

variable "auto_resolve_timeout" {
  type    = number
  default = null
}

variable "acknowledgement_timeout" {
  type    = number
  default = null
}

variable "auto_pause_notifications_parameters" {
  type = object({
    enabled = bool
    timeout = number
  })
  default = null
}

variable "create_events_api_v2_integration" {
  type    = bool
  default = true
}

variable "integration_name" {
  type    = string
  default = "Events API v2"
}
