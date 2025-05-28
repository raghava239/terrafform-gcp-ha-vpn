resource "google_compute_instance" "gcp-instance-01" {
  name = "gcp-instance-01"
  machine_type = "n2-standard-2"
  zone = "us-central1-a"

  tags = [ "gcp","vpn-instance" ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        vpn-instance = "gcp"
      }
    }
  }
  network_interface {
    network = google_compute_network.gcp-network-01.id
    subnetwork = google_compute_subnetwork.sn-gcp-uscentral1.id
  }
}