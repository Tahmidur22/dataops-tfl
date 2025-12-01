resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  
}

resource "azurerm_service_plan" "sp" {
  name                = "example-app-service-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "FC1"
  os_type             = "Linux"

}

resource "azurerm_function_app_flex_consumption" "function_app" {
  name                = "function-app-${var.resource_group_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.sp.id

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = var.storage_container_endpoint
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = var.storage_access_key
  runtime_name                = "python"
  runtime_version             = "3.12"
  maximum_instance_count      = 50
  instance_memory_in_mb       = 2048

  app_settings = {
    STORAGE_LANDING = var.storage_accounts["landing"].name
    STORAGE_STAGING = var.storage_accounts["staging"].name
    API_KEY         = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/api-key)"
    CONTAINER_NAME  = var.storage_accounts["landing"].container_name
    STORAGE_ACCOUNT_URL = var.storage_container_endpoint
  }

  site_config {}

  identity {
    type = "SystemAssigned"
  }
 
}