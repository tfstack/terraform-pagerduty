# terraform-pagerduty

Terraform modules for PagerDuty incident management and alert routing. The repository uses a multi-module layout so you can use only what you need.

## Layout

- **modules/users** — Create PagerDuty users with optional contact and notification rules.
- **modules/team** — Create a PagerDuty team.
- **modules/team-membership** — Associate users with teams (`pagerduty_team_membership`).
- **modules/schedule** — On-call schedules; pass PagerDuty user IDs from `modules/users`.
- **modules/escalation-policy** — Escalation policies with schedule or user targets (PagerDuty IDs).
- **modules/service** — PagerDuty technical service with optional Events API v2 inbound integration (for AMP Alertmanager and similar alert sources).

## Features

- Create PagerDuty users with optional contact/notification configuration
- Create teams and team memberships
- Create escalation policies targeting schedules or users
- Create a PagerDuty technical service
- Attach an Events API v2 integration and output the `integration_key` (routing key)

Compose schedule → escalation-policy → service for a full paging stack, or pass an existing escalation policy ID to `modules/service` alone.

## Authentication

The [PagerDuty Terraform provider](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest/docs) authenticates with an API access key.

### Create a PagerDuty API access key

1. In the PagerDuty web app, go to **Integrations** → **Developer Tools** → **API Access Keys**
2. Click **Create New API Key**
3. Add a description (for example `Terraform`) and create the key
4. Copy the key immediately — it is shown only once

Alternative (user-scoped token): avatar → **My Profile** → **User Settings** → create an API user token.

### Set the token for Terraform

```bash
export PAGERDUTY_TOKEN="your-api-key"
```

The provider reads `PAGERDUTY_TOKEN` by default. Do not commit tokens; `*.tfvars` files are gitignored.

### Minimum permissions

Exact RBAC varies by account. For the full module set, the API key typically needs:

- Schedules: read + write
- Escalation Policies: read + write
- Services: read + write
- Integrations: read + write
- Users: read + write
- Teams: read + write

For CI, store the token in a secret (for example `PAGERDUTY_TOKEN` in GitHub Actions).

## Usage

### Full stack (schedule → escalation → service)

```hcl
terraform {
  required_providers {
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "~> 3.0"
    }
  }
}

provider "pagerduty" {
  # token defaults to env PAGERDUTY_TOKEN
}

module "users" {
  source = "./modules/users"

  users = [
    { name = "Alice Example", email = "alice@example.com" },
    { name = "Bob Example", email = "bob@example.com" },
  ]
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

module "escalation" {
  source = "./modules/escalation-policy"

  name = "eks-21-platform"
  rules = [{
    escalation_delay_in_minutes = 15
    targets = [{
      type = "schedule_reference"
      id   = module.oncall.schedule_id
    }]
  }]
}

module "amp_alerts" {
  source = "./modules/service"

  name                 = "amp-eks-21"
  description          = "AMP Alertmanager alerts"
  escalation_policy_id = module.escalation.escalation_policy_id
}

output "integration_key" {
  value     = module.amp_alerts.integration_key
  sensitive = true
}
```

See [examples/platform-oncall](examples/platform-oncall) for a complete apply boundary.

### Service with escalation policy (no schedule)

```hcl
module "users" {
  source = "./modules/users"

  users = [{
    name  = "Alice Example"
    email = "alice@example.com"
  }]
}

module "escalation" {
  source = "./modules/escalation-policy"

  name = "amp-eks-21"
  rules = [{
    escalation_delay_in_minutes = 15
    targets = [{
      type = "user_reference"
      id   = module.users.user_ids["alice@example.com"]
    }]
  }]
}

module "amp_alerts" {
  source = "./modules/service"

  name                 = "amp-eks-21"
  escalation_policy_id = module.escalation.escalation_policy_id
}
```

See [examples/amp-receiver](examples/amp-receiver).

## AMP Alertmanager follow-up

This repo creates the PagerDuty side only. To wire AMP native PagerDuty receivers:

1. Store `integration_key` in AWS Secrets Manager (with a CMK trusted by `aps.amazonaws.com`)
2. Reference that secret from AMP Alertmanager `pagerduty_configs.routing_key`

See [Configure Alertmanager to send alerts to PagerDuty](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alertmanager-pagerduty-configure-alertmanager.html).

Treat `integration_key` as a credential. The module marks it `sensitive`.

## Examples

| Example | Description |
|---------|-------------|
| [amp-receiver](examples/amp-receiver) | Users + escalation policy + AMP service |
| [platform-oncall](examples/platform-oncall) | Users + schedule + escalation policy + AMP service |

## Tests

```bash
terraform test
```

Plan-only tests use a mocked PagerDuty provider and do not call the live API.

## License

See [LICENSE](LICENSE).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_pagerduty"></a> [pagerduty](#requirement\_pagerduty) | ~> 3.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
