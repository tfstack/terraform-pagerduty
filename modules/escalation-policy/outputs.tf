output "escalation_policy_id" {
  description = "ID of the escalation policy."
  value       = pagerduty_escalation_policy.this.id
}

output "escalation_policy_name" {
  description = "Name of the escalation policy."
  value       = pagerduty_escalation_policy.this.name
}
