# Frontend Repository
resource "github_actions_secret" "frontend_gcp_project" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_PROJECT"
  plaintext_value = var.project_id
}

resource "github_actions_secret" "frontend_artifact_registry_location" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_LOCATION"
  plaintext_value = google_artifact_registry_repository.application.location
}

resource "github_actions_secret" "frontend_artifact_registry_id" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_ID"
  plaintext_value = google_artifact_registry_repository.application.repository_id
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

resource "github_actions_secret" "frontend_public_ip_adress" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "PUBLIC_IP_ADDRESS"
  plaintext_value = google_compute_global_address.ingress_public_ip.address
}

resource "github_actions_secret" "frontend_manifest_repository" {
  repository      = var.app_config.frontend.repo_name
  secret_name     = "MANIFEST_REPOSITORY"
  plaintext_value = "${var.app_config.manifest.repo_user_name}/${var.app_config.manifest.repo_name}"
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
  plaintext_value = google_artifact_registry_repository.application.location
}

resource "github_actions_secret" "backend_artifact_registry_id" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_ARTIFACT_REGISTRY_ID"
  plaintext_value = google_artifact_registry_repository.application.repository_id
}

resource "github_actions_secret" "backend_workload_identity_provider" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "backend_workload_identity_service_account" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_workload_identity_federation.email
}

resource "github_actions_secret" "backend_service_account_key" {
  count           = var.db_config.is_enabled ? 1 : 0
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCS_SERVICE_ACCOUNT_KEY"
  plaintext_value = google_service_account_key.backend.private_key
}

resource "github_actions_secret" "backend_gcs_sql_bucket" {
  count           = var.db_config.is_enabled ? 1 : 0
  repository      = var.app_config.backend.repo_name
  secret_name     = "GCS_SQL_BUCKET"
  plaintext_value = google_storage_bucket.sql[0].name
}

resource "github_actions_secret" "backend_pat" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "PAT"
  plaintext_value = data.google_secret_manager_secret_version.github_token.secret_data
}

resource "github_actions_secret" "backend_db_instance_name" {
  count           = var.db_config.is_enabled ? 1 : 0
  repository      = var.app_config.backend.repo_name
  secret_name     = "DB_INSTANCE_NAME"
  plaintext_value = google_sql_database_instance.application[0].name
}

resource "github_actions_secret" "backend_db_name" {
  count           = var.db_config.is_enabled ? 1 : 0
  repository      = var.app_config.backend.repo_name
  secret_name     = "DB_NAME"
  plaintext_value = var.db_config.db_name
}


resource "github_actions_secret" "backend_manifest_repository" {
  repository      = var.app_config.backend.repo_name
  secret_name     = "MANIFEST_REPOSITORY"
  plaintext_value = "${var.app_config.manifest.repo_user_name}/${var.app_config.manifest.repo_name}"
}




# Manifest Files Repository
resource "github_actions_secret" "manifests_database_connection_name" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GCP_DATABASE_CONNECTION_NAME"
  plaintext_value = join("", google_sql_database_instance.application[*].connection_name)
}

resource "github_actions_secret" "manifests_workload_identity_provider" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "manifests_workload_identity_service_account" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GCP_WORKLOAD_IDENTITY_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_workload_identity_federation.email
}

resource "github_actions_secret" "manifests_gke_service_account" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GKE_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.node_pool.email
}

resource "github_actions_secret" "manifests_gke_cluster_name" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GKE_CLUSTER_NAME"
  plaintext_value = google_container_cluster.application.name
}

resource "github_actions_secret" "manifests_gke_cluster_location" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GKE_CLUSTER_LOCATION"
  plaintext_value = google_container_cluster.application.location
}

resource "github_actions_secret" "manifests_target_namespace" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GKE_TARGET_NAMESPACE"
  plaintext_value = var.app_config.target_namespace
}

resource "github_actions_secret" "manifests_backend_sa" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "GKE_BACKEND_SA"
  plaintext_value = var.app_config.backend.gke_service_account
}

resource "github_actions_secret" "manifests_public_ip_name" {
  repository      = var.app_config.manifest.repo_name
  secret_name     = "PUBLIC_IP_NAME"
  plaintext_value = google_compute_global_address.ingress_public_ip.name
}




