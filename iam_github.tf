#### Github Workload Identity Federation Service Account
resource "google_service_account" "github_workload_identity_federation" {
  account_id   = "${var.service_name}-github-wi-sa"
  display_name = "${var.service_name} GitHub Workload Identity Service Account"
}

# NOTE: Allow GitHub Actions to apply changes to GKE Cluster
resource "google_project_iam_member" "github_workload_identity_gke_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.github_workload_identity_federation.email}"
}

# NOTE: Backend Repository Service Account for load dump GitHub Actions
# using gsutil
resource "google_service_account" "backend" {
  account_id   = "${var.service_name}-backend-sa"
  display_name = "${var.service_name} Backend Service Account"
}

resource "google_project_iam_member" "backend_sql_admin" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.backend.email}"
}

# Create Service Account Key file
# Will be registerd as Github Secret in Backend Github Repository
# to authorize gsutil command
resource "google_service_account_key" "backend" {
  service_account_id = google_service_account.backend.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket_iam_member" "backend_bucket_admin" {
  bucket = google_storage_bucket.sql[0].name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.backend.email}"
}

resource "google_storage_bucket_iam_member" "backend_sql_bucket_admin" {
  count  = var.db_config.is_enabled ? 1 : 0
  bucket = google_storage_bucket.sql[0].name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_sql_database_instance.application[0].service_account_email_address}"
}

#### Outputs
output "github_workload_identity_sa_email" {
  value = google_service_account.github_workload_identity_federation.email
}
