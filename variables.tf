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

variable "zone" {
  type        = string
  description = "GCP Zone"
}

variable "db_config" {
  type        = map(any)
  description = "DB Config"
}

variable "frontend_config" {
  type        = map(any)
  description = "Frontend Config"
}


variable "backend_config" {
  type        = map(any)
  description = "Backend Config"
}