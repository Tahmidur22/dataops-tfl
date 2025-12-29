//backend config

terraform {
  backend "azurerm" {
    use_oidc             = true
  }
}