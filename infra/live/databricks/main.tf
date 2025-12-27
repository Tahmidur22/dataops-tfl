module "databricks_config_dev" {
  source        = "../../modules/databricks"
  spark_version = var.spark_version
  node_type_id  = var.node_type_id
  owner         = "data-engineering-team"
  environment   = var.environment
}