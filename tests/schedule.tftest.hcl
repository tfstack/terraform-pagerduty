mock_provider "pagerduty" {}

run "plan_schedule_with_two_users" {
  command = plan

  module {
    source = "./tests/setup-schedule"
  }

  variables {
    name      = "eks-21-platform-oncall"
    time_zone = "Australia/Sydney"
    layers = [{
      name                         = "Weekly rotation"
      start                        = "2026-06-09T09:00:00+10:00"
      rotation_virtual_start       = "2026-06-09T09:00:00+10:00"
      rotation_turn_length_seconds = 604800
      users                        = ["PUSER123", "PUSER456"]
    }]
  }

  assert {
    condition = (
      var.name == "eks-21-platform-oncall" &&
      var.time_zone == "Australia/Sydney" &&
      length(var.layers) == 1 &&
      length(var.layers[0].users) == 2
    )
    error_message = "Schedule plan should run with one layer and two user IDs."
  }
}
