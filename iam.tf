resource "google_service_account" "node_pool" {
  account_id   = "${var.service_name}-nodepool-sa"
  display_name = "${var.service_name} Node Pool Service Account"
}

resource "google_service_account" "github_workload_identity_federation" {
  account_id   = "${var.service_name}-github-wi-sa"
  display_name = "${var.service_name} GitHub Workload Identity Service Account"
}


# NOTE: Allow Node Pool instances has permission to connect to Cloud SQL Database
resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.node_pool.email}"
}

# NOTE: Setup Workload Identity between Node Pool Service Account <-> K8S Service Account: backend-sa
# So our backend pods will also have permission to connect to Cloud SQL
resource "google_service_account_iam_member" "argocd_workload_identity_user_backend" {
  count              = var.argocd_config.is_enabled ? 1 : 0
  service_account_id = google_service_account.node_pool.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.argocd_config.target_application_namespace}/backend-sa]"
}


# NOTE: Create when disabling ArgoCD
resource "google_service_account_iam_member" "default_workload_identity_user_backend" {
  count              = var.argocd_config.is_enabled ? 0 : 1
  service_account_id = google_service_account.node_pool.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/backend-sa]"
}

output "node_pool_sa_email" {
  value = google_service_account.node_pool.email
}

output "github_workload_identity_sa_email" {
  value = google_service_account.github_workload_identity_federation.email
}
