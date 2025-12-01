resource "azurerm_databricks_workspace" "data_workspace" {
    name                = "dbw-${var.resource_group_name}"
    location            = var.location
    resource_group_name = var.resource_group_name
    sku                 = "standard"
}