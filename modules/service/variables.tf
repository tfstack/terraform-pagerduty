variable "name" {
  description = "Name of the PagerDuty technical service."
  type        = string
}

variable "description" {
  description = "Description of the PagerDuty technical service."
  type        = string
  default     = null
}

variable "escalation_policy_id" {
  description = "ID of the escalation policy assigned to this service."
  type        = string
}

variable "alert_creation" {
  description = "Controls whether alerts are created for this service. Must be create_alerts_and_incidents for Events API v2 integrations."
  type        = string
  default     = "create_alerts_and_incidents"
}

variable "auto_resolve_timeout" {
  description = "Time in seconds before an incident auto-resolves. Set to null to disable."
  type        = number
  default     = null
}

variable "acknowledgement_timeout" {
  description = "Time in seconds before an acknowledged incident re-enters the triggered state. Set to null to disable."
  type        = number
  default     = null
}

variable "auto_pause_notifications_parameters" {
  description = "Optional auto-pause settings for low-urgency incidents."
  type = object({
    enabled = bool
    timeout = number
  })
  default = null
}

variable "create_events_api_v2_integration" {
  description = "Controls whether an Events API v2 inbound integration is created for this service."
  type        = bool
  default     = true
}

variable "integration_name" {
  description = "Name of the Events API v2 integration."
  type        = string
  default     = "Events API v2"
}
