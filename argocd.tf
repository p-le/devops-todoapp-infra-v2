# NOTE: Create argocd namespace and deploy ArgoCD to this namespace
resource "kubernetes_namespace" "argocd" {
  count = var.argocd_config.is_enabled ? 1 : 0
  depends_on = [
    google_container_node_pool.primary_nodes
  ]
  metadata {
    labels = {
      role = var.argocd_config.target_namespace
    }
    name = var.argocd_config.target_namespace
  }
}

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

resource "kubectl_manifest" "argocd" {
  count = var.argocd_config.is_enabled ? length(data.kubectl_file_documents.argocd_manifests[0].documents) : 0
  depends_on = [
    google_container_node_pool.primary_nodes,
    kubernetes_namespace.argocd[0]
  ]
  override_namespace = kubernetes_namespace.argocd[0].id
  yaml_body          = element(data.kubectl_file_documents.argocd_manifests[0].documents, count.index)
}

resource "kubectl_manifest" "application" {
  count = var.argocd_config.is_enabled ? 1 : 0
  depends_on = [
    google_container_node_pool.primary_nodes,
    kubernetes_namespace.argocd[0],
    kubectl_manifest.argocd[0]
  ]
  override_namespace = kubernetes_namespace.argocd[0].id
  yaml_body = templatefile("${path.module}/argocd/application.yaml", {
    APPLICATION_NAME      = var.service_name,
    ARGOCD_NAMESPACE      = kubernetes_namespace.argocd[0].id
    REPO_URL              = var.argocd_config.target_repository_url
    APPLICATION_NAMESPACE = kubernetes_namespace.application.id
  })
}

resource "kubernetes_secret" "argocd_private_ssh_key" {
  count = var.argocd_config.is_enabled ? 1 : 0
  metadata {
    name      = "${var.argocd_config.target_repository_name}-private-ssh-key"
    namespace = kubernetes_namespace.argocd[0].id
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    type          = "git"
    url           = var.argocd_config.target_repository_url
    sshPrivateKey = data.google_secret_manager_secret_version.argocd_private_key[0].secret_data
  }
}

resource "github_repository_deploy_key" "argocd_deploy_key" {
  count      = var.argocd_config.is_enabled ? 1 : 0
  title      = "Argocd Deploy Key"
  repository = var.argocd_config.target_repository_name
  key        = data.google_secret_manager_secret_version.argocd_public_key[0].secret_data
  read_only  = true
}
