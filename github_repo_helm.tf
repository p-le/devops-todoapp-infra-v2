resource "github_repository_deploy_key" "argocd_deploy_key" {
  count      = var.argocd_config.is_enabled ? 1 : 0
  title      = "Create Deploy Key to Target Repositories for ArgoCD to be able to sync"
  repository = var.app_config.helm_chart.repo_name
  key        = data.google_secret_manager_secret_version.argocd_public_key[0].secret_data
  read_only  = true
}
