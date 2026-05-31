resource "terraform_data" "rotation_anchor" {
  input = var.rotation_anchor != "" ? var.rotation_anchor : jsonencode(var.layers)
}

resource "pagerduty_schedule" "this" {
  name        = var.name
  time_zone   = var.time_zone
  description = var.description
  teams       = var.team_id == null ? [] : [var.team_id]

  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [terraform_data.rotation_anchor]
  }

  dynamic "layer" {
    for_each = var.layers
    content {
      name                         = layer.value.name
      start                        = layer.value.start
      end                          = layer.value.end
      rotation_virtual_start       = layer.value.rotation_virtual_start
      rotation_turn_length_seconds = layer.value.rotation_turn_length_seconds
      users                        = layer.value.users

      dynamic "restriction" {
        for_each = layer.value.restrictions
        content {
          type              = restriction.value.type
          start_time_of_day = restriction.value.start_time_of_day
          duration_seconds  = restriction.value.duration_seconds
          start_day_of_week = restriction.value.type == "weekly_restriction" ? restriction.value.start_day_of_week : null
        }
      }
    }
  }
}
