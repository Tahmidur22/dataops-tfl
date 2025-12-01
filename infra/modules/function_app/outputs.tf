output "identity_principal_id" {
  value = azurerm_function_app_flex_consumption.function_app.identity[0].principal_id
}

output "function_app_name" {
  value = azurerm_function_app_flex_consumption.function_app.name
}