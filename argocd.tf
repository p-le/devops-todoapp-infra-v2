# NOTE: Create argocd namespace and deploy ArgoCD to this namespace
resource "kubernetes_namespace" "argocd" {
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
      role = var.argocd_config.target_application_namespace
    }
    name = var.argocd_config.target_application_namespace
  }
}

resource "kubectl_manifest" "argocd" {
  count = length(data.kubectl_file_documents.argocd_manifests.documents)
  depends_on = [
    google_container_node_pool.primary_nodes,
    kubernetes_namespace.argocd
  ]
  override_namespace = kubernetes_namespace.argocd.id
  yaml_body          = element(data.kubectl_file_documents.argocd_manifests.documents, count.index)
}

resource "kubectl_manifest" "application" {
  depends_on = [
    google_container_node_pool.primary_nodes,
    kubernetes_namespace.argocd,
    kubectl_manifest.argocd
  ]
  override_namespace = kubernetes_namespace.argocd.id
  yaml_body = templatefile("${path.module}/argocd/application.yaml", {
    APPLICATION_NAME      = var.service_name,
    ARGOCD_NAMESPACE      = kubernetes_namespace.argocd.id
    REPO_URL              = var.argocd_config.target_repository_url
    APPLICATION_NAMESPACE = kubernetes_namespace.application.id
  })
}

resource "kubernetes_secret" "argocd_private_ssh_key" {
  metadata {
    name      = "${var.argocd_config.target_repository_name}-private-ssh-key"
    namespace = kubernetes_namespace.argocd.id
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type          = "git"
    url           = var.argocd_config.target_repository_url
    sshPrivateKey = data.google_secret_manager_secret_version.argocd_ssh_private_key.secret_data
  }
}

resource "github_repository_deploy_key" "argocd_deploy_key" {
  title      = "Argocd Deploy Key"
  repository = var.argocd_config.target_repository_name
  key        = data.google_secret_manager_secret_version.argocd_ssh_public_key.secret_data
  read_only  = true
}
