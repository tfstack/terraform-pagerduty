# Escalation Policy Module

Creates a PagerDuty escalation policy with ordered rules and targets. `user_reference` targets must use PagerDuty user IDs from `modules/users` or another source.

## Usage

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

  name = "eks-21-platform"
  rules = [{
    escalation_delay_in_minutes = 15
    targets = [{
      type = "user_reference"
      id   = module.users.user_ids["alice@example.com"]
    }]
  }]
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
