# Service Module

Creates a PagerDuty technical service with an optional Events API v2 inbound integration.

## Usage

```hcl
module "service" {
  source = "./modules/service"

  name                 = "amp-eks-21"
  description          = "AMP Alertmanager alerts"
  escalation_policy_id = "PABCDEF"
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
