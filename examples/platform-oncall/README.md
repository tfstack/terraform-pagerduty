# Platform On-Call Example

Creates a full PagerDuty paging stack for AMP alerts on a greenfield account:

1. **Users** (name and email required)
2. On-call **schedule** with weekly rotation
3. **Escalation policy** targeting that schedule
4. **Service** with Events API v2 integration for AMP Alertmanager

## Prerequisites

- PagerDuty account; user emails must satisfy any account domain restriction
- `PAGERDUTY_TOKEN` exported (see root [README](../../README.md))

## Usage

```bash
export PAGERDUTY_TOKEN="your-api-key"

terraform init
terraform plan -var='users=[{name="John Example",email="john@rocketmail.com"}]'
terraform apply -var='users=[{name="John Example",email="john@rocketmail.com"}]'
```

After apply, retrieve the integration key:

```bash
terraform output -raw integration_key
```

Store that value in AWS Secrets Manager for AMP Alertmanager `pagerduty_configs.routing_key`.

## Notes

- This example creates real PagerDuty resources.
- On-call schedules use the classic `pagerduty_schedule` resource.
- Run `terraform destroy` when you are done testing.
