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

module "service" {
  source = "../../modules/service"

  name                                = var.name
  description                         = var.description
  escalation_policy_id                = var.escalation_policy_id
  alert_creation                      = var.alert_creation
  auto_resolve_timeout                = var.auto_resolve_timeout
  acknowledgement_timeout             = var.acknowledgement_timeout
  auto_pause_notifications_parameters = var.auto_pause_notifications_parameters
  create_events_api_v2_integration    = var.create_events_api_v2_integration
  integration_name                    = var.integration_name
}
