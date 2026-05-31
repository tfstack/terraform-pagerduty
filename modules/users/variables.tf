variable "users" {
  description = "PagerDuty users to create or reference. Set existing = true to look up a pre-existing user without managing them."
  type = list(object({
    name        = string
    email       = string
    existing    = optional(bool, false)
    role        = optional(string, "user")
    job_title   = optional(string)
    license     = optional(string)
    description = optional(string)
    color       = optional(string)
    time_zone   = optional(string)
    contact_methods = optional(list(object({
      label            = string
      type             = string
      address          = string
      country_code     = optional(number)
      device_type      = optional(string)
      send_short_email = optional(bool)
    })), [])
    notification_rules = optional(list(object({
      start_delay_in_minutes = number
      urgency                = string
      contact_method = object({
        type  = string
        id    = optional(string)
        label = optional(string)
      })
    })), [])
    handoff_notification_rules = optional(list(object({
      notify_advance_in_minutes = number
      handoff_type              = optional(string)
      contact_methods = list(object({
        type  = string
        id    = optional(string)
        label = optional(string)
      }))
    })), [])
  }))
}
