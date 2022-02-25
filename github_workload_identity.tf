# NOTE: Delete Workload Identity Pool is an SOFT DELETE Action,
# The soft-delted pool will be deleted after 30 days
# So it's better to add an suffix after pool name to avoid duplication.
resource "random_id" "github_workload_identity_pool_suffix" {
  byte_length = 2
}

resource "google_iam_workload_identity_pool" "github" {
  provider                  = google-beta
  workload_identity_pool_id = "github-pool-${random_id.github_workload_identity_pool_suffix.hex}"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# NOTE: allow to get access token from Frontend Github Repository
resource "google_service_account_iam_member" "github_workload_identity_user_frontend" {
  service_account_id = google_service_account.github_workload_identity_federation.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.app_config.frontend.repo_user_name}/${var.app_config.frontend.repo_name}"
}

# NOTE: allow to get access token from Backend Github Repository
resource "google_service_account_iam_member" "github_workload_identity_user_backend" {
  service_account_id = google_service_account.github_workload_identity_federation.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.app_config.backend.repo_user_name}/${var.app_config.backend.repo_name}"
}
