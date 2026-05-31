output "schedule_id" {
  description = "ID of the on-call schedule."
  value       = pagerduty_schedule.this.id
}

output "schedule_name" {
  description = "Name of the on-call schedule."
  value       = pagerduty_schedule.this.name
}
