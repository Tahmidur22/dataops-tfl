variable "resource_group_name" {
  description = "value of the resource group name"
  type        = string
}
variable "location" {
  description = "value of the location"
  type        = string
}
variable "storage_account_name" {
  description = "value of the storage account name"
  type        = string
}
variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}
variable "ci_cd_sp_display_name" {
  description = "The display name of the CI/CD service principal"
  type        = string
}
