resource "github_actions_secret" "frontend_gcp_project" {
  repository      = var.repositories.frontend.repo_name
  secret_name     = "GCP_PROJECT"
  plaintext_value = var.project_id
}

resource "github_actions_secret" "backend_gcp_project" {
  repository      = var.repositories.backend.repo_name
  secret_name     = "GCP_PROJECT"
  plaintext_value = var.project_id
}

resource "github_actions_secret" "frontend_artifact_registry_location" {
  repository      = var.repositories.frontend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_LOCATION"
  plaintext_value = google_artifact_registry_repository.todoapp.location
}

resource "github_actions_secret" "backend_artifact_registry_location" {
  repository      = var.repositories.backend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_LOCATION"
  plaintext_value = google_artifact_registry_repository.todoapp.location
}

resource "github_actions_secret" "frontend_artifact_registry_id" {
  repository      = var.repositories.frontend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_ID"
  plaintext_value = google_artifact_registry_repository.todoapp.repository_id
}

resource "github_actions_secret" "backend_artifact_registry_id" {
  repository      = var.repositories.backend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_ID"
  plaintext_value = google_artifact_registry_repository.todoapp.repository_id
}

resource "github_actions_secret" "frontend_workload_identity_provider" {
  repository      = var.repositories.frontend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "backend_workload_identity_provider" {
  repository      = var.repositories.backend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "frontend_workload_identity_service_account" {
  repository      = var.repositories.frontend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_workload_identity_federation.email
}

resource "github_actions_secret" "backend_workload_identity__service_account" {
  repository      = var.repositories.backend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_workload_identity_federation.email
}
