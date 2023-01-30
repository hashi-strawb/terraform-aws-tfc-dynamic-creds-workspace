variable "oidc_provider_arn" {
  type        = string
  description = "The ARN for the app.terraform.io OIDC provider"
}

variable "oidc_provider_client_id_list" {
  type        = list(string)
  default     = ["aws.workload.identity"]
  description = "The audience value(s) to use in run identity tokens. Defaults to aws.workload.identity, but if your OIDC provider uses something different, set it here"
}

variable "tfc_organization_name" {
  type        = string
  default     = "fancycorp"
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_workspace_name" {
  type        = string
  default     = "bootstrap"
  description = "The name of the workspace"
}

variable "tfc_workspace_project" {
  type        = string
  default     = "Default Project"
  description = "The name of the project the workspace lives in"
}
locals {
  tfc_workspace_project_nospaces = replace(var.tfc_workspace_project, " ", "")
}
