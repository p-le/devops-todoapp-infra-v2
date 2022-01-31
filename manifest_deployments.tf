data "kubectl_path_documents" "manifests" {
  pattern = "${path.module}/manifests/*.yaml"
}

resource "kubectl_manifest" "deployment_manifests" {
  depends_on = [
    google_container_node_pool.primary_nodes
  ]
  count     = length(data.kubectl_path_documents.manifests.documents)
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}
