data "google_compute_zones" "available" {
  region = var.region
}

data "http" "db_migration_tables" {
  url = "https://raw.githubusercontent.com/p-le/test-todoapp-backend/master/migrations/tables.sql"
}
