resource "azurerm_role_assignment" "this" {
  for_each = { for idx, val in var.role_assignments : idx => val }

  principal_id         = each.value.principal_id
  role_definition_name = each.value.role_definition_name
  scope                = each.value.scope
}