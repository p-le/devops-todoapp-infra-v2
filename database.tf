resource "random_id" "db_name_suffix" {
  count       = var.db_config.is_enabled ? 1 : 0
  byte_length = 4
}

resource "google_sql_database" "application" {
  count    = var.db_config.is_enabled ? 1 : 0
  name     = var.db_config.db_name
  instance = google_sql_database_instance.application[count.index].name
}

resource "google_sql_database_instance" "application" {
  count            = var.db_config.is_enabled ? 1 : 0
  name             = "${var.service_name}-${random_id.db_name_suffix[count.index].hex}"
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

resource "google_sql_user" "application" {
  count    = var.db_config.is_enabled ? 1 : 0
  name     = var.db_config.db_user
  instance = google_sql_database_instance.application[count.index].name
  host     = "%"
  password = var.db_config.db_password
}

output "database_connection_name" {
  value = join("", google_sql_database_instance.application[*].connection_name)
}
