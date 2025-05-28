
// Network //

resource "google_compute_network" "onprem-network-01" {
     name = "onprem-network-01"
     auto_create_subnetworks = false
     routing_mode = "GLOBAL"
     mtu = 1450
     
}

//Subnetwork//

resource "google_compute_subnetwork" "sn-onprem-uscentral1" {
     name = "sn-onprem-uscentral1"
     ip_cidr_range = "192.168.0.0/24"
     private_ip_google_access = false
     region = "us-central1"
     network = google_compute_network.onprem-network-01.id
     stack_type = "IPV4_ONLY"
     
     log_config {
       aggregation_interval = "INTERVAL_10_MIN"
       flow_sampling = 0.5
       metadata = "INCLUDE_ALL_METADATA"
     }
}

//Subnetwork//

resource "google_compute_subnetwork" "sn-onprem-uscentral2" {
     name = "sn-onprem-uscentral2"
     ip_cidr_range = "10.20.0.0/24"
     private_ip_google_access = false
     region = "us-central1"
     network = google_compute_network.onprem-network-01.id
     stack_type = "IPV4_ONLY"
     
     log_config {
       aggregation_interval = "INTERVAL_10_MIN"
       flow_sampling = 0.5
       metadata = "INCLUDE_ALL_METADATA"
     }
}

// Firewall policy  - Egress//

resource "google_compute_firewall" "onprem-egress" {
  network = google_compute_network.onprem-network-01.id
  name = "on-prem-01-outbound"
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

resource "google_compute_firewall" "on-prem-firewall2" {
  network = google_compute_network.onprem-network-01.id
  name = "on-prem-01-inbound"
  direction = "INGRESS"
  priority = 1

  allow {
    protocol = "tcp"
    ports = ["22", "80","90"]
  }

 allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  destination_ranges = ["0.0.0.0/0"]
}