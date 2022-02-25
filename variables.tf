variable "service_name" {
  type        = string
  description = "Service Name"
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "db_config" {
  type        = map(any)
  description = "DB Config"
}

variable "app_config" {
  type = object({
    github_token_secret_id = string
    target_namespace       = string
    backend                = map(any)
    frontend               = map(any)
    manifest               = map(any)
  })
  description = "Application Config"
}

variable "argocd_config" {
  type        = map(any)
  description = "ArgoCD Config (Version, etc)"
}
