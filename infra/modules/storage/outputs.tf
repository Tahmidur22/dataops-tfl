output "storage_account_name" {
  value =  {
   for k, v in azurerm_storage_account.storage_account : k => v.name
  }
}

output "container_name" {
  value = { 
    for k,v in azurerm_storage_container.storage_container : k=> v.name
  }
}

output "primary_blob_endpoint" {
  value = { 
    for k, v in azurerm_storage_account.storage_account : k => v.primary_blob_endpoint
  }
}

output "primary_access_key" {
  value = { 
    for k,v in azurerm_storage_account.storage_account : k=> v.primary_access_key
  }
  sensitive = true
}

output "storage_account_ids" {
  value = { 
    for k,v in azurerm_storage_account.storage_account : k=> v.id
  }
}

