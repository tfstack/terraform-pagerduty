# Team Module

Creates a PagerDuty team. Associate users with `modules/team-membership`.

## Usage

```hcl
module "team" {
  source = "./modules/team"

  name        = "Platform"
  description = "Platform on-call"
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
