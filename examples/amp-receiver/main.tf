terraform {
  required_version = ">= 1.0"

  required_providers {
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "~> 3.0"
    }
  }
}

provider "pagerduty" {}

variable "users" {
  description = "PagerDuty users to create and notify. See modules/users for supported fields."
  type = list(object({
    name        = string
    email       = string
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

variable "team_name" {
  description = "Optional PagerDuty team name. When set, creates a team and adds users as members."
  type        = string
  default     = null
}

variable "team_description" {
  description = "Description for the optional PagerDuty team."
  type        = string
  default     = null
}

variable "service_name" {
  description = "Name of the PagerDuty service to create."
  type        = string
  default     = "amp-eks-21"
}

variable "escalation_policy_name" {
  description = "Name of the escalation policy."
  type        = string
  default     = "amp-eks-21"
}

module "users" {
  source = "../../modules/users"

  users = var.users
}

module "team" {
  count  = var.team_name == null ? 0 : 1
  source = "../../modules/team"

  name        = var.team_name
  description = var.team_description
}

module "team_membership" {
  count  = var.team_name == null ? 0 : 1
  source = "../../modules/team-membership"

  memberships = {
    for user in var.users : user.email => {
      team_id = module.team[0].team_id
      user_id = module.users.user_ids[user.email]
    }
  }
}

module "escalation" {
  source = "../../modules/escalation-policy"

  name    = var.escalation_policy_name
  team_id = var.team_name == null ? null : module.team[0].team_id
  rules = [{
    escalation_delay_in_minutes = 15
    targets = [
      for user in var.users : {
        type = "user_reference"
        id   = module.users.user_ids[user.email]
      }
    ]
  }]
}

module "service" {
  source = "../../modules/service"

  name                 = var.service_name
  description          = "Inbound alerts from Amazon Managed Prometheus (Alertmanager)."
  escalation_policy_id = module.escalation.escalation_policy_id
}
