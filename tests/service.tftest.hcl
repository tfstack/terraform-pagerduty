mock_provider "pagerduty" {}

run "plan_full_stack" {
  command = plan

  module {
    source = "./tests/setup"
  }

  variables {
    name                 = "amp-eks-21"
    description          = "AMP alerts for eks-21"
    escalation_policy_id = "PABCDEF"
  }

  assert {
    condition = (
      var.name == "amp-eks-21" &&
      var.escalation_policy_id == "PABCDEF" &&
      var.create_events_api_v2_integration
    )
    error_message = "Full stack plan should run with service name, escalation policy, and Events API v2 integration enabled."
  }
}

run "plan_service_only_without_integration" {
  command = plan

  module {
    source = "./tests/setup"
  }

  variables {
    name                             = "amp-service-only"
    escalation_policy_id             = "PABCDEF"
    create_events_api_v2_integration = false
  }

  assert {
    condition     = var.create_events_api_v2_integration == false
    error_message = "Events API v2 integration should be disabled for service-only plan."
  }

  assert {
    condition     = output.integration_id == null
    error_message = "integration_id should be null when Events API v2 integration is disabled."
  }
}
