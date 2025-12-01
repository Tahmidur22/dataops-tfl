variable "role_assignments" {
  description = "List of role assignments"
  type = list(object({
    principal_id         = string
    role_definition_name = string
    scope                = string
  }))
}
