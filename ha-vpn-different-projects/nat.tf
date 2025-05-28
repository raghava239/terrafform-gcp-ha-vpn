

resource "google_compute_router" "nat-router-02" {
  name = "nat-router-02"
  network = google_compute_network.onprem-network-01.id
  region = "us-central1"
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat-gw-01" {
  name = "nat-gw-01"
  router = "nat-router-02"
  region = "us-central1"
  nat_ip_allocate_option =  "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true 
    filter = "ERRORS_ONLY"
  }
}

## GCP Network


resource "google_compute_router_nat" "gcp-nat-gw-01" {
  name = "gcp-nat-gw-01"
  router = "gcp-nw-router-01"
  region = "us-central1"
  nat_ip_allocate_option =  "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true 
    filter = "ERRORS_ONLY"
  }
}
