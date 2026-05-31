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

module "team_membership" {
  source = "../../modules/team-membership"

  memberships = var.memberships
}
