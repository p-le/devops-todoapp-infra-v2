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

variable "repositories" {
  type        = map(any)
  description = "GitHub Repositories"
}

variable "argocd_config" {
  type        = map(any)
  description = "ArgoCD Config (Version, etc)"
}
