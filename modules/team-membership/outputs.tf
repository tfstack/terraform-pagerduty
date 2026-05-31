output "membership_ids" {
  description = "Map of membership key to membership ID."
  value = {
    for key, membership in pagerduty_team_membership.this :
    key => membership.id
  }
}
