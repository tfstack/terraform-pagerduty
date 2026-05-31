mock_provider "pagerduty" {}

run "plan_team_membership" {
  command = plan

  module {
    source = "./tests/setup-team-membership"
  }

  variables {
    memberships = {
      "alice@example.com" = {
        team_id = "PTeam123"
        user_id = "PUSER123"
        role    = "manager"
      }
    }
  }

  assert {
    condition     = var.memberships["alice@example.com"].team_id == "PTeam123"
    error_message = "Team membership plan should run with team and user IDs."
  }
}
