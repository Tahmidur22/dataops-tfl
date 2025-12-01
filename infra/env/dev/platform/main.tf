data "azurerm_client_config" "current" {}

module "rg" {
  source              = "../../../modules/rg"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "storage" {
  source = "../../../modules/storage"

  resource_group_name  = module.rg.resource_group_name
  location             = module.rg.location
  storage_account_name = var.storage_account_name
  container_name       = "data"
}

module "key_vault" {
  source              = "../../../modules/key_vault"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
}

module "function_app" {
  source                     = "../../../modules/function_app"
  resource_group_name        = module.rg.resource_group_name
  location                   = module.rg.location
  storage_container_endpoint = "${module.storage.primary_blob_endpoint["landing"]}${module.storage.container_name["landing"]}"
  storage_access_key         = module.storage.primary_access_key["landing"]
  storage_accounts = {
    landing = {
      name           = module.storage.storage_account_name["landing"]
      container_name = module.storage.container_name["landing"]
    }
    staging = {
      name           = module.storage.storage_account_name["staging"]
      container_name = module.storage.container_name["staging"]
    }
  }
  key_vault_uri = module.key_vault.key_vault_uri

  depends_on = [module.key_vault]
}

data "azuread_service_principal" "ci_cd" {
  display_name = "cicd-oidc"
}

module "rbac" {
  source = "../../../modules/rbac"
  role_assignments = [
    {
      principal_id         = module.function_app.identity_principal_id
      role_definition_name = "Key Vault Secrets User"
      scope                = module.key_vault.key_vault_id
    },
    {
      principal_id         = data.azuread_service_principal.ci_cd.object_id
      role_definition_name = "Key Vault Secrets Officer"
      scope                = module.key_vault.key_vault_id
    },
    {
      principal_id         = module.function_app.identity_principal_id
      role_definition_name = "Storage Blob Data Contributor"
      scope                = module.storage.storage_account_ids["landing"]
    },
    {
      principal_id         = module.function_app.identity_principal_id
      role_definition_name = "Storage Blob Data Contributor"
      scope                = module.storage.storage_account_ids["staging"]
    }
  ]

  depends_on = [module.key_vault, module.function_app, module.storage]
}

module "data_factory" {
  source              = "../../../modules/data_factory"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
}

module "databricks_workspace_dev" {
  source              = "../../../modules/databricks_workspace"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location
}





