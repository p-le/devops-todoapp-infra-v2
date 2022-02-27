#### GKE Node Pool Service Account
resource "google_service_account" "node_pool" {
  account_id   = "${var.service_name}-nodepool-sa"
  display_name = "${var.service_name} Node Pool Service Account"
}

# NOTE: Allow Node Pool instances has permission to connect to Cloud SQL Database
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

#### Outputs
output "node_pool_sa_email" {
  value = google_service_account.node_pool.email
}
