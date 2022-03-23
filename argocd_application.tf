# Config Helm Chart Repository for ArgoCD with SSH Private Key
// resource "kubectl_manifest" "helm_chart_secret" {
//   count = var.argocd_config.is_enabled ? 1 : 0
//   depends_on = [
//     google_container_node_pool.primary_nodes,
//     kubernetes_namespace.argocd[0],
//     kubectl_manifest.argocd[0]
//   ]
//   override_namespace = kubernetes_namespace.argocd[0].id
//   yaml_body = templatefile("${path.module}/argocd/helm_chart_secret.yaml", {
//     APPLICATION_NAMESPACE = var.app_config.target_namespace
//     HELM_REPO_URL         = var.helm_chart.gh_page_url
//     SSH_PRIVATE_KEY       = split("\n", data.google_secret_manager_secret_version.argocd_private_key[0].secret_data)
//   })
// }

# Config declaratively Application object in ArgoCD
resource "kubectl_manifest" "application" {
  count = var.argocd_config.is_enabled ? 1 : 0
  depends_on = [
    google_container_node_pool.primary_nodes,
    kubernetes_namespace.argocd[0],
    kubectl_manifest.argocd[0]
  ]
  override_namespace = kubernetes_namespace.argocd[0].id
  yaml_body = templatefile("${path.module}/argocd/application.yaml", {
    APPLICATION_NAME                            = var.service_name,
    ARGOCD_NAMESPACE                            = kubernetes_namespace.argocd[0].id
    HELM_REPO_URL                               = var.app_config.helm_chart.gh_page_url
    APPLICATION_NAMESPACE                       = kubernetes_namespace.application.id
    INGRESS_EXTERNAL_IP_RESOURCE_NAME           = google_compute_global_address.ingress_public_ip.name
    INGRESS_EXTERNAL_IP_ADDRESS                 = google_compute_global_address.ingress_public_ip.address
    BACKEND_SERVICE_ACCOUNT                     = var.app_config.backend.gke_service_account
    IMAGE_REGISTRY                              = local.image_registry
    GKE_WORKLOAD_IDENTITY_SERVICE_ACCOUNT_EMAIL = google_service_account.node_pool.email
  })
}

