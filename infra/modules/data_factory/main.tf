resource "azurerm_data_factory" "adf" {
    name                = "adf-${var.resource_group_name}"
    location            = var.location
    resource_group_name = var.resource_group_name
}
