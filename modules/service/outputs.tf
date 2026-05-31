output "service_id" {
  description = "ID of the PagerDuty service."
  value       = pagerduty_service.this.id
}

output "service_name" {
  description = "Name of the PagerDuty service."
  value       = pagerduty_service.this.name
}

output "service_html_url" {
  description = "URL of the PagerDuty service in the web UI."
  value       = pagerduty_service.this.html_url
}

output "integration_id" {
  description = "ID of the Events API v2 integration."
  value       = try(pagerduty_service_integration.events_api_v2[0].id, null)
}

output "integration_key" {
  description = "Integration key (routing key) for the Events API v2 integration."
  value       = try(pagerduty_service_integration.events_api_v2[0].integration_key, null)
  sensitive   = true
}
