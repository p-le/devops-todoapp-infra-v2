resource "random_id" "todoapp_db_name_suffix" {
  count       = var.db_config.is_enabled ? 1 : 0
  byte_length = 4
}

resource "google_sql_database" "todoapp" {
  count    = var.db_config.is_enabled ? 1 : 0
  name     = var.db_config.db_name
  instance = google_sql_database_instance.todoapp[count.index].name
}

resource "google_sql_database_instance" "todoapp" {
  count            = var.db_config.is_enabled ? 1 : 0
  name             = "${var.service_name}-${random_id.todoapp_db_name_suffix[count.index].hex}"
  region           = var.region
  database_version = var.db_config.db_version

  settings {
    tier = var.db_config.db_tier

    ip_configuration {
      ipv4_enabled = true
    }
  }

  deletion_protection = "false"
}

resource "google_sql_user" "todoapp" {
  count    = var.db_config.is_enabled ? 1 : 0
  name     = var.db_config.db_user
  instance = google_sql_database_instance.todoapp[count.index].name
  host     = "%"
  password = var.db_config.db_password
}

resource "google_storage_bucket_object" "todoapp_tables" {
  count   = var.db_config.is_enabled ? 1 : 0
  name    = "tables.sql"
  content = data.http.db_migration_tables.body
  bucket  = "asia-northeast1-devops-demo"
}

output "db_instance_name" {
  value = var.db_config.is_enabled ? google_sql_database_instance.todoapp[0].name : "disabled"
}
