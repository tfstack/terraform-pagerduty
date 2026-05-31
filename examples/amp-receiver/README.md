# AMP Receiver Example

Creates everything needed for AMP Alertmanager paging on a greenfield PagerDuty account:

1. **Users** via `modules/users` (optional contact/notification rules)
2. Optional **team** + **team membership**
3. **Escalation policy** targeting those users
4. **Service** with Events API v2 integration

Suitable for [Amazon Managed Prometheus Alertmanager native PagerDuty receivers](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alertmanager-pagerduty-configure-alertmanager.html).

For on-call schedule rotation, see [platform-oncall](../platform-oncall).

## Prerequisites

- PagerDuty account; user emails must satisfy any account domain restriction
- `PAGERDUTY_TOKEN` exported (see root [README](../../README.md))

## Usage

Minimal (name and email only; `role` defaults to `user`):

```bash
export PAGERDUTY_TOKEN="your-api-key"

terraform init
terraform plan -var='users=[{name="John Example",email="john@rocketmail.com"}]'
terraform apply -var='users=[{name="John Example",email="john@rocketmail.com"}]'
```

Multiple users:

```bash
terraform apply -var='users=[{name="Alice Example",email="alice@rocketmail.com"},{name="Bob Example",email="bob@rocketmail.com"}]'
```

With optional user fields:

```bash
terraform apply -var='users=[{
  name="John Example",
  email="john@rocketmail.com",
  role="user",
  job_title="Platform Engineer"
}]'
```

With optional team:

```bash
terraform apply \
  -var='users=[{name="John Example",email="john@rocketmail.com"}]' \
  -var='team_name=Platform'
```

With optional phone contact and notification rule:

```bash
terraform apply -var='users=[{
  name="John Example",
  email="john@rocketmail.com",
  contact_methods=[{
    label="Mobile",
    type="phone_contact_method",
    address="4155551212"
  }],
  notification_rules=[{
    start_delay_in_minutes=0,
    urgency="high",
    contact_method={
      type="phone_contact_method_reference",
      label="Mobile"
    }
  }]
}]'
```

### User fields

| Field | Required | Default |
|-------|----------|---------|
| `name` | yes | — |
| `email` | yes | — |
| `role` | no | `"user"` |
| `job_title` | no | omit |
| `license` | no | omit |
| `description` | no | omit (provider sets `Managed by Terraform`) |
| `color` | no | omit |
| `time_zone` | no | omit |
| `contact_methods` | no | `[]` |
| `notification_rules` | no | `[]` |
| `handoff_notification_rules` | no | `[]` |

Optional example variables:

| Variable | Description |
|----------|-------------|
| `team_name` | Creates a team and adds all users as members |
| `team_description` | Team description when `team_name` is set |

Prefer a tfvars file for non-trivial input:

```hcl
# terraform.tfvars (gitignored)
users = [{
  name      = "John Example"
  email     = "john@rocketmail.com"
  job_title = "Platform Engineer"
}]
```

```bash
terraform apply
```

After apply, retrieve the integration key:

```bash
terraform output -raw integration_key
```

Store that value in AWS Secrets Manager for AMP Alertmanager `pagerduty_configs.routing_key`.

## Notes

- This example creates real PagerDuty resources.
- Run `terraform destroy` when you are done testing.
