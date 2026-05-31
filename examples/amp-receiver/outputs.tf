output "user_ids" {
  description = "Created PagerDuty user IDs keyed by email."
  value       = module.users.user_ids
}

output "team_id" {
  description = "PagerDuty team ID when team_name was set."
  value       = try(module.team[0].team_id, null)
}

output "escalation_policy_id" {
  description = "PagerDuty escalation policy ID."
  value       = module.escalation.escalation_policy_id
}

output "service_id" {
  description = "PagerDuty service ID."
  value       = module.service.service_id
}

output "service_html_url" {
  description = "PagerDuty service URL in the web UI."
  value       = module.service.service_html_url
}

output "integration_key" {
  description = "Events API v2 integration key (routing key) for AMP Alertmanager pagerduty_configs."
  value       = module.service.integration_key
  sensitive   = true
}
