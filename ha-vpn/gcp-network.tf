
// Network //

resource "google_compute_network" "gcp-network-01" {
     name = "gcp-network-02"
     auto_create_subnetworks = false
     mtu = 1450
     
}

//Subnetwork//

resource "google_compute_subnetwork" "sn-gcp-uscentral1" {
     name = "sn-gcp-uscentral1"
     ip_cidr_range = "10.10.0.0/24"
     private_ip_google_access = false
     region = "us-central1"
     network = google_compute_network.gcp-network-01.id
     stack_type = "IPV4_ONLY"
     
     log_config {
       aggregation_interval = "INTERVAL_10_MIN"
       flow_sampling = 0.5
       metadata = "INCLUDE_ALL_METADATA"
     }
}

resource "google_compute_subnetwork" "sn-02-gcp-uscentral1" {
     name = "sn-02-gcp-uscentral1"
     ip_cidr_range = "10.20.0.0/24"
     private_ip_google_access = false
     region = "us-central1"
     network = google_compute_network.gcp-network-01.id
     stack_type = "IPV4_ONLY"
     
     log_config {
       aggregation_interval = "INTERVAL_10_MIN"
       flow_sampling = 0.5
       metadata = "INCLUDE_ALL_METADATA"
     }
}

// Firewall policy  - Egress//

resource "google_compute_firewall" "gcp-egress" {
  network = google_compute_network.gcp-network-01.id
  name = "gcp-egress"
  direction = "EGRESS"
  priority = 2

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22","80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

// Firewall policy  - INGRESS //

resource "google_compute_firewall" "gcp-ingress" {
  network = google_compute_network.gcp-network-01.id
  name = "gcp-ingress"
  direction = "INGRESS"
  priority = 1

  allow {
    protocol = "tcp"
    ports = ["22", "80","90"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0","104.132.250.74/32"]
  destination_ranges = ["0.0.0.0/0"]
}

/*

// Service Networking

# Create an IP address

# Create a global internal IP address for VPC peering
resource "google_compute_global_address" "private_ip_address" {
  name                     = "private-ip-address"
  purpose                  = "VPC_PEERING"
  address_type             = "INTERNAL"
  prefix_length            = 16
  network                  = google_compute_network.gcp-network-01.id
}

# Establish a Service Networking connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.gcp-network-01.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  
  depends_on = [google_compute_global_address.private_ip_address]
}
*/