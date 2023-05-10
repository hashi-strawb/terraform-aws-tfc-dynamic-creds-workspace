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

variable "cred_type" {
  type = string

  validation {
    condition     = contains(["workspace", "project"], var.cred_type)
    error_message = "Must specify credential type, one of: workspace, project"
  }
}

locals {
  is_project = var.cred_type == "project"
}


variable "tfc_workspace_project_name" {
  type        = string
  description = "The name of the project the workspace lives in"
  default     = "*"

  # TODO: Condition, if workspace name and id not set, then this must be something other than *
}

variable "tfc_workspace_project_id" {
  type        = string
  description = "The ID of the project the workspace lives in"
  default     = ""

  # TODO: Condition, if workspace name and id not set, then this must be something other than ""
}


locals {
  tfc_workspace_project_nospaces = replace(
    replace(
      var.tfc_workspace_project_name, " ", ""
    ),
    "*",
    ""
  )
}
