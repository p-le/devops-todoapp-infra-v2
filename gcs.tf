resource "random_id" "sql_bucket_suffix" {
  count       = var.db_config.is_enabled ? 1 : 0
  byte_length = 4
}

# NOTE: add postfix after name to avoid bucket unique name validation
resource "google_storage_bucket" "sql" {
  count         = var.db_config.is_enabled ? 1 : 0
  name          = "${var.service_name}-${var.region}-sql-${random_id.sql_bucket_suffix[count.index].hex}"
  location      = upper(var.region)
  force_destroy = true
}
