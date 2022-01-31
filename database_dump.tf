resource "random_id" "todoapp_bucket_suffix" {
  count       = var.db_config.is_enabled ? 1 : 0
  byte_length = 4
}

# NOTE: add postfix after name to avoid bucket unique name validation
resource "google_storage_bucket" "todoapp" {
  count         = var.db_config.is_enabled ? 1 : 0
  name          = "${var.service_name}-${var.region}-sql-${random_id.todoapp_db_name_suffix[count.index].hex}"
  location      = upper(var.region)
  force_destroy = true
}

resource "google_storage_bucket_object" "todoapp_tables" {
  count   = var.db_config.is_enabled ? 1 : 0
  name    = "tables.sql"
  content = data.http.db_migration_tables.body
  bucket  = google_storage_bucket.todoapp[0].name
}
