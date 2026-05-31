mock_provider "pagerduty" {}

run "plan_team" {
  command = plan

  module {
    source = "./tests/setup-team"
  }

  variables {
    name        = "Platform"
    description = "Platform on-call"
  }

  assert {
    condition     = var.name == "Platform"
    error_message = "Team plan should run with the requested team name."
  }
}
