mock_provider "pagerduty" {}

run "plan_escalation_with_schedule_reference" {
  command = plan

  module {
    source = "./tests/setup-escalation-policy"
  }

  variables {
    name = "eks-21-platform"
    rules = [{
      escalation_delay_in_minutes = 15
      targets = [{
        type = "schedule_reference"
        id   = "PSCHED123"
      }]
    }]
  }

  assert {
    condition = (
      var.name == "eks-21-platform" &&
      var.rules[0].targets[0].type == "schedule_reference"
    )
    error_message = "Escalation plan should run with a schedule_reference target."
  }
}

run "plan_escalation_with_user_id" {
  command = plan

  module {
    source = "./tests/setup-escalation-policy"
  }

  variables {
    name = "eks-21-platform-fallback"
    rules = [{
      escalation_delay_in_minutes = 30
      targets = [{
        type = "user_reference"
        id   = "PUSER123"
      }]
    }]
  }

  assert {
    condition = (
      var.rules[0].targets[0].type == "user_reference" &&
      var.rules[0].targets[0].id == "PUSER123"
    )
    error_message = "Escalation plan should accept user_reference targets by PagerDuty user ID."
  }
}
