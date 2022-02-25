resource "google_compute_network" "vpc" {
  name                    = "${var.service_name}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.region}-${var.service_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.2.0.0/16"

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

resource "google_compute_firewall" "default" {
  name    = "${var.service_name}-nodepool-fw-default"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = [var.service_name]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "ingress_public_ip" {
  name         = "${var.service_name}-ingress-public-ipv4-address"
  address_type = "EXTERNAL"
}
