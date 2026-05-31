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

module "team" {
  source = "../../modules/team"

  name         = var.name
  description  = var.description
  default_role = var.default_role
  parent       = var.parent
}
