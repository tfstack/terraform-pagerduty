resource "pagerduty_service" "this" {
  name                    = var.name
  description             = var.description
  escalation_policy       = var.escalation_policy_id
  alert_creation          = var.alert_creation
  auto_resolve_timeout    = var.auto_resolve_timeout
  acknowledgement_timeout = var.acknowledgement_timeout

  dynamic "auto_pause_notifications_parameters" {
    for_each = var.auto_pause_notifications_parameters == null ? [] : [var.auto_pause_notifications_parameters]
    content {
      enabled = auto_pause_notifications_parameters.value.enabled
      timeout = auto_pause_notifications_parameters.value.timeout
    }
  }
}

resource "pagerduty_service_integration" "events_api_v2" {
  count = var.create_events_api_v2_integration ? 1 : 0

  name    = var.integration_name
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.this.id
}
