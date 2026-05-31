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
  description = "PagerDuty users to create and include in the on-call rotation."
  type = list(object({
    name  = string
    email = string
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
  description = "Name of the PagerDuty service for AMP alerts."
  type        = string
  default     = "amp-eks-21"
}

variable "schedule_name" {
  description = "Name of the on-call schedule."
  type        = string
  default     = "eks-21-platform-oncall"
}

variable "escalation_policy_name" {
  description = "Name of the escalation policy."
  type        = string
  default     = "eks-21-platform"
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

module "oncall" {
  source = "../../modules/schedule"

  name      = var.schedule_name
  time_zone = "Australia/Sydney"
  team_id   = var.team_name == null ? null : module.team[0].team_id
  layers = [{
    name                         = "Weekly rotation"
    start                        = "2026-06-09T09:00:00+10:00"
    rotation_virtual_start       = "2026-06-09T09:00:00+10:00"
    rotation_turn_length_seconds = 604800
    users                        = module.users.user_ids_ordered
  }]
}

module "escalation" {
  source = "../../modules/escalation-policy"

  name    = var.escalation_policy_name
  team_id = var.team_name == null ? null : module.team[0].team_id
  rules = [{
    escalation_delay_in_minutes = 15
    targets = [{
      type = "schedule_reference"
      id   = module.oncall.schedule_id
    }]
  }]
}

module "amp_alerts" {
  source = "../../modules/service"

  name                 = var.service_name
  description          = "Inbound alerts from Amazon Managed Prometheus (Alertmanager)."
  escalation_policy_id = module.escalation.escalation_policy_id
}
