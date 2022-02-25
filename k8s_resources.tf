resource "kubernetes_namespace" "application" {
  depends_on = [
    google_container_node_pool.primary_nodes
  ]
  metadata {
    labels = {
      role = var.app_config.target_namespace
    }
    name = var.app_config.target_namespace
  }
}

resource "kubernetes_secret" "db_credentials" {
  count = var.db_config.is_enabled ? 1 : 0
  metadata {
    name      = "db-credentials"
    namespace = kubernetes_namespace.application.id
  }
  data = {
    password = data.google_secret_manager_secret_version.db_password.secret_data
    user     = var.db_config.db_user
  }
}
