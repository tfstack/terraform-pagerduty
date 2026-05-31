variable "name" {
  description = "Name of the on-call schedule."
  type        = string
}

variable "time_zone" {
  description = "IANA time zone for the schedule (for example Australia/Sydney)."
  type        = string
}

variable "layers" {
  description = "Schedule layers defining on-call rotations. Each layer users entry must be a PagerDuty user ID."
  type = list(object({
    name                         = string
    start                        = string
    rotation_virtual_start       = string
    rotation_turn_length_seconds = number
    users                        = list(string)
    end                          = optional(string)
    restrictions = optional(list(object({
      type              = string
      start_time_of_day = string
      duration_seconds  = number
      start_day_of_week = optional(number) # 1=Monday … 7=Sunday (PagerDuty API)
    })), [])
  }))
}

variable "description" {
  description = "Description of the on-call schedule."
  type        = string
  default     = null
}

variable "team_id" {
  description = "Optional PagerDuty team ID to associate with the schedule."
  type        = string
  default     = null
}

variable "rotation_anchor" {
  description = "Changing this value forces schedule replacement (PagerDuty does not reliably update layer start in place)."
  type        = string
  default     = ""
}
