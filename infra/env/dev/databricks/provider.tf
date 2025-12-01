terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.16.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }

}
data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "sttfldatatfstate-rg"
    storage_account_name = "sttfldatatfstate"
    container_name       = "sttfldatatfstate-container"
    key                  = "tfl-data/dev.tfstate"
  }
}


provider "databricks" {
  host                        = data.terraform_remote_state.platform.outputs.databricks_workspace_url
  azure_workspace_resource_id = data.terraform_remote_state.platform.outputs.databricks_workspace_id
}
