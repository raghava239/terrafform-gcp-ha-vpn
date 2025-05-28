resource "google_compute_instance" "onprem-instance-01" {
  name = "onprem-instance-01"
  machine_type = "n2-standard-2"
  zone = "us-central1-a"
  allow_stopping_for_update = true 

  tags = [ "gcp","vpn-instance" ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        vpn-instance = "onprem"
      }
    }
  }
  network_interface {
    network = google_compute_network.onprem-network-01.id
    subnetwork = google_compute_subnetwork.sn-onprem-uscentral2.id
  }
}