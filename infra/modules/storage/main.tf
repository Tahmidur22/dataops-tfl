locals {
  storage_accounts = {
    landing = {
      name = "landing"
      container_name = "landing-container"
    }
    staging = {
      name = "staging"
      container_name = "staging-container"
    }
  }
}

resource "azurerm_storage_account" "storage_account" {
    for_each = local.storage_accounts
    name                     = "${var.storage_account_name}${each.value.name}"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
    for_each = local.storage_accounts
    name                  = "${var.container_name}${each.value.container_name}"
    storage_account_id    = azurerm_storage_account.storage_account[each.key].id
    container_access_type = "private"
}