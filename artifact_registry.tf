resource "google_artifact_registry_repository" "todoapp" {
  provider      = google-beta
  location      = var.region
  repository_id = "${var.service_name}-repository"
  description   = "${var.service_name} Docker Repository"
  format        = "DOCKER"
}

# NOTE: Allow pulling Container Image in Artifact Registry from GKE Node Pool Instance
resource "google_artifact_registry_repository_iam_member" "registry_reader" {
  provider   = google-beta
  location   = var.region
  repository = google_artifact_registry_repository.todoapp.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.node_pool.email}"
}
