# AWS Dynamic Creds for TFC Workspaces

Set up IAM roles in your AWS account for TFC Dynamic Creds.

Note: This is currently limited to 1 IAM role, used for both Plan and Apply, and this is hard-coded to full admin permissions on the account.

I'll probably fix that later...


<!-- BEGIN_TF_DOCS -->
## Requirements

This requires an OIDC provider for the TFC org to be pre-created in AWS.

As you can only have one of these per AWS account per URL (e.g. app.terraform.io), then
this module does not create it.

Use https://github.com/hashi-strawb/terraform-aws-tfc-dynamic-creds-provider/ to create the
OIDC provider in AWS first, and pass in the ARN

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.workspace_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [tfe_variable.workspace_enable_aws_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.workspace_tfc_aws_role_arn](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_workspace.workspace](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | The ARN for the app.terraform.io OIDC provider | `string` | n/a | yes |
| <a name="input_oidc_provider_client_id_list"></a> [oidc\_provider\_client\_id\_list](#input\_oidc\_provider\_client\_id\_list) | The audience value(s) to use in run identity tokens. Defaults to aws.workload.identity, but if your OIDC provider uses something different, set it here | `list(string)` | <pre>[<br>  "aws.workload.identity"<br>]</pre> | no |
| <a name="input_tfc_organization_name"></a> [tfc\_organization\_name](#input\_tfc\_organization\_name) | The name of your Terraform Cloud organization | `string` | `"fancycorp"` | no |
| <a name="input_tfc_workspace_name"></a> [tfc\_workspace\_name](#input\_tfc\_workspace\_name) | The name of the workspace | `string` | `"bootstrap"` | no |
| <a name="input_tfc_workspace_project"></a> [tfc\_workspace\_project](#input\_tfc\_workspace\_project) | The name of the project the workspace lives in | `string` | `"Default Project"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
