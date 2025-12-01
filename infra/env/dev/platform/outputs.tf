output "resource_group_name" {
  value = module.rg.resource_group_name
}

output "resource_group_location" {
  value = module.rg.location
}

output "databricks_workspace_url" {
  value = module.databricks_workspace_dev.workspace_url
}

output "databricks_workspace_id" {
  value = module.databricks_workspace_dev.workspace_id
}
