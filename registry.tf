resource "google_artifact_registry_repository" "devops_demo" {
  provider      = google-beta
  location      = var.region
  repository_id = "${var.service_name}-repository"
  description   = "Docker Repository for Devops Demo"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "registry_reader" {
  provider   = google-beta
  location   = var.region
  repository = "devops-cicd-repository"

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.node_pool.email}"
}
