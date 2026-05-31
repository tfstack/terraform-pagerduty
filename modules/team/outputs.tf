output "team_id" {
  description = "ID of the PagerDuty team."
  value       = pagerduty_team.this.id
}

output "team_name" {
  description = "Name of the PagerDuty team."
  value       = pagerduty_team.this.name
}

output "team_html_url" {
  description = "URL of the PagerDuty team in the web UI."
  value       = pagerduty_team.this.html_url
}
