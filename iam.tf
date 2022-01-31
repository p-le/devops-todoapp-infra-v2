resource "google_service_account" "node_pool" {
  account_id   = "${var.service_name}-sa"
  display_name = "${var.service_name} Service Account"
}
