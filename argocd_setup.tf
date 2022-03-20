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

resource "kubectl_manifest" "argocd" {
  count = var.argocd_config.is_enabled ? length(data.kubectl_file_documents.argocd_manifests[0].documents) : 0
  depends_on = [
    google_container_node_pool.primary_nodes,
    kubernetes_namespace.argocd[0]
  ]
  override_namespace = kubernetes_namespace.argocd[0].id
  yaml_body          = element(data.kubectl_file_documents.argocd_manifests[0].documents, count.index)
}

