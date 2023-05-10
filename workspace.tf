#
# For credentials scoped to a Workspace...
#



#
# Create AWS role for the workspace to Assume
#

resource "aws_iam_role" "workspace_role" {
  count = local.is_project ? 0 : 1

  name = "tfc-${var.tfc_organization_name}-${local.tfc_workspace_project_nospaces}-${var.tfc_workspace_name}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "Federated": "${var.oidc_provider_arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "app.terraform.io:aud": "${one(var.oidc_provider_client_id_list)}"
       },
       "StringLike": {
         "app.terraform.io:sub": "organization:${var.tfc_organization_name}:project:${var.tfc_workspace_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
       }
     }
   }
 ]
}
EOF

  # TODO: this is waaaaay too much access; limit it to just what's needed
  # TODO: separate policies for Plan and Apply (e.g. readonly and admin)
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  lifecycle {
    create_before_destroy = true
  }
}



#
# Set required Vars in TFC
#

resource "tfe_variable" "workspace_enable_aws_provider_auth" {
  count = local.is_project ? 0 : 1

  workspace_id = var.tfc_workspace_id

  key      = "TFC_AWS_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for AWS."
}

resource "tfe_variable" "workspace_tfc_aws_role_arn" {
  count = local.is_project ? 0 : 1

  workspace_id = var.tfc_workspace_id

  key      = "TFC_AWS_RUN_ROLE_ARN"
  value    = one(aws_iam_role.workspace_role).arn
  category = "env"

  description = "The AWS role arn runs will use to authenticate."
}
