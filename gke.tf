resource "google_container_cluster" "todoapp" {
  name        = "${var.service_name}-cluster"
  description = "${var.service_name} GKE Cluster"
  location    = local.target_deploy_zone
  network     = google_compute_network.vpc.id
  subnetwork  = google_compute_subnetwork.subnet.id
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.subnet.secondary_ip_range.1.range_name
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name               = "${var.service_name}-primary-nodepool"
  location           = local.target_deploy_zone
  cluster            = google_container_cluster.todoapp.name
  initial_node_count = 1
  max_pods_per_node  = 16

  node_config {
    preemptible     = false
    machine_type    = "e2-medium"
    tags            = [var.service_name]
    service_account = google_service_account.node_pool.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }
}
