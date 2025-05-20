variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "eastus"
}

variable "data_factory_name" {
  type        = string
  description = "Name of the Azure Data Factory instance"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}

variable "github_account_name" {
  type        = string
  description = "GitHub account name for source control"
  default     = ""
}

variable "github_branch_name" {
  type        = string
  description = "GitHub branch name"
  default     = "main"
}

variable "github_url" {
  type        = string
  description = "GitHub URL"
  default     = ""
}

variable "github_repository_name" {
  type        = string
  description = "GitHub repository name"
  default     = ""
}

variable "github_root_folder" {
  type        = string
  description = "Root folder in the GitHub repository"
  default     = "/"
}