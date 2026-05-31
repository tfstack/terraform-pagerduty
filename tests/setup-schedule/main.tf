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

module "schedule" {
  source = "../../modules/schedule"

  name        = var.name
  time_zone   = var.time_zone
  layers      = var.layers
  description = var.description
  team_id     = var.team_id
}
