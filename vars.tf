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
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of the workspace. If not specified, module will create Project-scoped creds"
  default     = ""
}

variable "tfc_workspace_id" {
  type        = string
  description = "The ID of the workspace. If not specified, module will create Project-scoped creds"
  default     = ""
}

locals {
  is_project = (var.tfc_workspace_name == "" && var.tfc_workspace_id == "")
}


variable "tfc_workspace_project" {
  type        = string
  description = "The name of the project the workspace lives in"
}
locals {
  tfc_workspace_project_nospaces = replace(var.tfc_workspace_project, " ", "")
}
