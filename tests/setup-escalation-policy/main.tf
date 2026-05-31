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

module "escalation_policy" {
  source = "../../modules/escalation-policy"

  name        = var.name
  rules       = var.rules
  description = var.description
  num_loops   = var.num_loops
  team_id     = var.team_id
}
