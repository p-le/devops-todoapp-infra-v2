#### GKE Node Pool Service Account
# NOTE: Allow Node Pool instances has permission to connect to Cloud SQL Database
resource "google_service_account" "node_pool" {
  account_id   = "${var.service_name}-nodepool-sa"
  display_name = "${var.service_name} Node Pool Service Account"
}

resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.node_pool.email}"
}

# NOTE: Setup Workload Identity between Node Pool Service Account <-> K8S Service Account: backend-sa
# So our backend pods will also have permission to connect to Cloud SQL
resource "google_service_account_iam_member" "gke_workload_identity_user_backend" {
  service_account_id = google_service_account.node_pool.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.app_config.target_namespace}/${var.app_config.backend.gke_service_account}]"
}

#### Github Workload Identity Federation Service Account
resource "google_service_account" "github_workload_identity_federation" {
  account_id   = "${var.service_name}-github-wi-sa"
  display_name = "${var.service_name} GitHub Workload Identity Service Account"
}


#### Backend Service Account
resource "google_service_account" "backend" {
  account_id   = "${var.service_name}-backend-sa"
  display_name = "${var.service_name} Backend Service Account"
}

# Create Key file to create Secret in Backend Github Repository
resource "google_service_account_key" "backend" {
  service_account_id = google_service_account.backend.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket_iam_member" "backend" {
  bucket = google_storage_bucket.sql[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.backend.email}"
}

#### Output
output "node_pool_sa_email" {
  value = google_service_account.node_pool.email
}

output "github_workload_identity_sa_email" {
  value = google_service_account.github_workload_identity_federation.email
}
