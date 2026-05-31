# Schedule Module

Creates a PagerDuty on-call schedule using the classic `pagerduty_schedule` resource. Create users first with `modules/users` and pass their IDs in each layer `users` list.

## Usage

```hcl
module "users" {
  source = "./modules/users"

  users = [{
    name  = "Alice Example"
    email = "alice@example.com"
  }]
}

module "oncall" {
  source = "./modules/schedule"

  name      = "eks-21-platform-oncall"
  time_zone = "Australia/Sydney"
  layers = [{
    name                         = "Weekly rotation"
    start                        = "2026-06-09T09:00:00+10:00"
    rotation_virtual_start       = "2026-06-09T09:00:00+10:00"
    rotation_turn_length_seconds = 604800
    users                        = module.users.user_ids_ordered
  }]
}
```

Each layer object:

| Field | Description | Required |
|-------|-------------|:--------:|
| name | Layer name. | yes |
| start | Layer start time (RFC 3339). | yes |
| rotation_virtual_start | Effective rotation start (RFC 3339). | yes |
| rotation_turn_length_seconds | On-call shift length in seconds. | yes |
| users | Ordered PagerDuty user IDs in the rotation. | yes |
| end | Optional layer end time. | no |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
