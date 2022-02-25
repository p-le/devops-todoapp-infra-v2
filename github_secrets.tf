# Frontend Repository
resource "github_actions_secret" "frontend_gcp_project" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_PROJECT"
  plaintext_value = var.project_id
}

resource "github_actions_secret" "frontend_artifact_registry_location" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_LOCATION"
  plaintext_value = google_artifact_registry_repository.todoapp.location
}

resource "github_actions_secret" "frontend_artifact_registry_id" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_ID"
  plaintext_value = google_artifact_registry_repository.todoapp.repository_id
}

resource "github_actions_secret" "frontend_workload_identity_provider" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "frontend_workload_identity_service_account" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_workload_identity_federation.email
}

resource "github_actions_secret" "frontend_pat" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "PAT"
  plaintext_value = data.google_secret_manager_secret_version.github_token.secret_data
}

# Backend Repository
resource "github_actions_secret" "backend_gcp_project" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_PROJECT"
  plaintext_value = var.project_id
}

resource "github_actions_secret" "backend_artifact_registry_location" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_LOCATION"
  plaintext_value = google_artifact_registry_repository.todoapp.location
}

resource "github_actions_secret" "backend_artifact_registry_id" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_ID"
  plaintext_value = google_artifact_registry_repository.todoapp.repository_id
}

resource "github_actions_secret" "backend_workload_identity_provider" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "backend_workload_identity__service_account" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_workload_identity_federation.email
}

resource "github_actions_secret" "backend_pat" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "PAT"
  plaintext_value = data.google_secret_manager_secret_version.github_token.secret_data
}

# Manifest Files Repository
resource "github_actions_secret" "manifests_database_connection_name" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GCP_DATABASE_CONNECTION_NAME"
  plaintext_value = join("", google_sql_database_instance.todoapp[*].connection_name)
}

resource "github_actions_secret" "manifests_gke_workload_identity_email" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GKE_WORKLOAD_IDENTITY_EMAIL"
  plaintext_value = google_service_account.node_pool.email
}









