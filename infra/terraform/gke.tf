resource "google_container_cluster" "test-cluster" {
  name     = var.gke_cluster_name
  location = var.gke_region

  initial_node_count       = 1

  network    = google_compute_network.vpc.name
}

resource "google_compute_network" "vpc" {
  name                    = "${var.gke_project_id}-vpc"
  auto_create_subnetworks = "true"
}