output "user_ids" {
  description = "Created PagerDuty user IDs keyed by email."
  value       = module.users.user_ids
}

output "schedule_id" {
  description = "PagerDuty on-call schedule ID."
  value       = module.oncall.schedule_id
}

output "escalation_policy_id" {
  description = "PagerDuty escalation policy ID."
  value       = module.escalation.escalation_policy_id
}

output "service_id" {
  description = "PagerDuty service ID."
  value       = module.amp_alerts.service_id
}

output "service_html_url" {
  description = "PagerDuty service URL in the web UI."
  value       = module.amp_alerts.service_html_url
}

output "integration_key" {
  description = "Events API v2 integration key (routing key) for AMP Alertmanager pagerduty_configs."
  value       = module.amp_alerts.integration_key
  sensitive   = true
}
