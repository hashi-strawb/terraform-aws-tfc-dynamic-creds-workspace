#
# For credentials scoped to a Project...
#




#
# Create AWS role for the project to Assume
#

resource "aws_iam_role" "project_role" {
  count = local.is_project ? 1 : 0

  name = "tfc-${var.tfc_organization_name}-${local.tfc_workspace_project_nospaces}"

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
         "app.terraform.io:sub": "organization:${var.tfc_organization_name}:project:${var.tfc_workspace_project_name}:workspace:*:run_phase:*"
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

resource "tfe_variable_set" "creds" {
  count        = local.is_project ? 1 : 0
  name         = "AWS Dynamic Creds: ${var.tfc_workspace_project_name} Project"
  description  = "AWS Auth & Role details for Dynamic AWS Creds"
  organization = var.tfc_organization_name
}


resource "tfe_variable" "project_enable_aws_provider_auth" {
  count    = local.is_project ? 1 : 0
  key      = "TFC_AWS_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for AWS."

  variable_set_id = one(tfe_variable_set.creds).id
}

resource "tfe_variable" "project_tfc_aws_role_arn" {
  count    = local.is_project ? 1 : 0
  key      = "TFC_AWS_RUN_ROLE_ARN"
  value    = one(aws_iam_role.project_role).arn
  category = "env"

  description = "The AWS role arn runs will use to authenticate."

  variable_set_id = one(tfe_variable_set.creds).id
}

resource "tfe_project_variable_set" "creds_to_project" {
  count           = local.is_project ? 1 : 0
  variable_set_id = one(tfe_variable_set.creds).id
  project_id      = var.tfc_workspace_project_id
}
