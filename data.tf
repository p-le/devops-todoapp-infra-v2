data "google_compute_zones" "available" {
  region = var.region
}

data "google_secret_manager_secret_version" "github_token" {
  secret = var.secrets_ids.github_token
}

data "google_secret_manager_secret_version" "db_password" {
  secret = var.secrets_ids.db_password
}

#### ArgoCD
# Read ArgoCD Install Manifest YAML remotely
# Read registered Secret Manager Value
data "http" "argocd_install" {
  count = var.argocd_config.is_enabled ? 1 : 0
  url   = "https://raw.githubusercontent.com/argoproj/argo-cd/${var.argocd_config.target_version}/manifests/install.yaml"
}

data "google_secret_manager_secret_version" "argocd_public_key" {
  count  = var.argocd_config.is_enabled ? 1 : 0
  secret = var.secrets_ids.argocd_public_key
}

data "google_secret_manager_secret_version" "argocd_private_key" {
  count  = var.argocd_config.is_enabled ? 1 : 0
  secret = var.secrets_ids.argocd_private_key
}

data "kubectl_file_documents" "argocd_manifests" {
  count   = var.argocd_config.is_enabled ? 1 : 0
  content = data.http.argocd_install[0].body
}

# NOTE: specifiy target zone to create Zonal GKE Cluster
locals {
  target_deploy_zone = data.google_compute_zones.available.names[0]
  image_registry     = "${google_artifact_registry_repository.application.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.application.repository_id}"
}

