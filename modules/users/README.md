# Users Module

Creates PagerDuty users and optional contact/notification configuration. See [pagerduty_user](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs/resources/user) and related resources.

Pre-existing users (for example the account owner) can be referenced with `existing = true` — Terraform looks them up via `data.pagerduty_user` and does not create or manage their profile, contact methods, or notification rules. They still appear in `user_ids` for team membership and schedules.

Associate users with teams via `modules/team-membership` (not deprecated `teams` on `pagerduty_user`).

## Usage

```hcl
module "users" {
  source = "./modules/users"

  users = [{
    name     = "Account Owner"
    email    = "owner@example.com"
    existing = true
  }, {
    name  = "Alice Example"
    email = "alice@example.com"
    contact_methods = [{
      label   = "Mobile"
      type    = "phone_contact_method"
      address = "4155551212"
    }]
    notification_rules = [{
      start_delay_in_minutes = 0
      urgency                = "high"
      contact_method = {
        type  = "phone_contact_method_reference"
        label = "Mobile"
      }
    }]
  }]
}
```

Each user object supports `pagerduty_user` fields plus optional:

| Field | Description |
|-------|-------------|
| existing | When `true`, look up the user by email only; do not create or manage profile, contact methods, or notification rules. |
| contact_methods | Additional `pagerduty_user_contact_method` resources (managed users only). |
| notification_rules | `pagerduty_user_notification_rule` resources. Reference contact methods by `label` or explicit `id`. |
| handoff_notification_rules | `pagerduty_user_handoff_notification_rule` resources. |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
