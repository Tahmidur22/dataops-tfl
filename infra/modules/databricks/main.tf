//https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.16.0"
    }
  }
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "Shared Autoscaling"
  spark_version           = var.spark_version 
  node_type_id            = var.node_type_id 
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 50
  }

  custom_tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}