
/*
resource "google_container_cluster" "standard-cluster-01" {
  name = "standard-cluster-01"
  location = "us-central1"
  initial_node_count = 1
  network = google_compute_network.gcp-network-01.id
  subnetwork = google_compute_subnetwork.sn-gcp-uscentral1.id
  deletion_protection = false

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true 
    master_ipv4_cidr_block = "10.0.0.0/28"
  }
} */