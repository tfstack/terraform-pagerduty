# Team Membership Module

Associates PagerDuty users with teams via `pagerduty_team_membership` (replaces deprecated `teams` on `pagerduty_user`).

## Usage

```hcl
module "team_membership" {
  source = "./modules/team-membership"

  memberships = {
    "alice@example.com" = {
      team_id = module.team.team_id
      user_id = module.users.user_ids["alice@example.com"]
      role    = "manager"
    }
  }
}
```

Each membership object:

| Field | Description | Required |
|-------|-------------|:--------:|
| team_id | PagerDuty team ID. | yes |
| user_id | PagerDuty user ID. | yes |
| role | Team role (`observer`, `responder`, `manager`, etc.). | no |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
