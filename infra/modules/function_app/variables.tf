variable "resource_group_name" { 
  description = "The name of the resource group"
  type = string 
}
variable "location" { 
  description = "The location of the resource group"
  type = string 
}
variable "storage_container_endpoint" { 
  description = "The endpoint of the storage container"
  type = string 
}
variable "storage_access_key" { 
  description = "The access key of the storage account"
  type = string 
}
variable "storage_accounts" { 
  description = "A map of storage accounts and their container names"
  type = map(object({ name = string, container_name = string })) 
}
variable "key_vault_uri" { 
  description = "The URI of the Key Vault"
  type = string 
}