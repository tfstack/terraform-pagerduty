resource "pagerduty_team" "this" {
  name         = var.name
  description  = var.description
  default_role = var.default_role
  parent       = var.parent
}
