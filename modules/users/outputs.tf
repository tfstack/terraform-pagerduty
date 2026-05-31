output "user_ids" {
  description = "Map of user email to PagerDuty user ID (managed and existing users)."
  value       = local.user_id_by_email
}

output "user_ids_ordered" {
  description = "PagerDuty user IDs in the same order as var.users."
  value       = [for user in var.users : local.user_id_by_email[user.email]]
}

output "contact_method_ids" {
  description = "Map of user_email:label to contact method ID."
  value = {
    for key, contact_method in pagerduty_user_contact_method.this :
    key => contact_method.id
  }
}

output "notification_rule_ids" {
  description = "Map of notification rule key to notification rule ID."
  value = {
    for key, rule in pagerduty_user_notification_rule.this :
    key => rule.id
  }
}

output "handoff_notification_rule_ids" {
  description = "Map of handoff notification rule key to rule ID."
  value = {
    for key, rule in pagerduty_user_handoff_notification_rule.this :
    key => rule.id
  }
}
