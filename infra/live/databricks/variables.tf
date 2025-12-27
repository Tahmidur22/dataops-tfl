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
variable "spark_version" {
  description = "Databricks Spark version"
  type        = string
}
variable "node_type_id" {
  description = "Databricks Node Type ID"
  type        = string
}
variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

