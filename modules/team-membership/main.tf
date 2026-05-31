resource "pagerduty_team_membership" "this" {
  for_each = var.memberships

  team_id = each.value.team_id
  user_id = each.value.user_id
  role    = each.value.role
}
