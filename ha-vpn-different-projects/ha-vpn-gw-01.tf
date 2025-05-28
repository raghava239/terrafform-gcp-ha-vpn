
# gcp nw vpn gw 
# link https://cloud.google.com/network-connectivity/docs/vpn/how-to/automate-vpn-setup-with-terraform 

resource "google_compute_ha_vpn_gateway" "gcp-nw-vpn-gw-01" {
  region = "us-central1"
  name = "gcp-ha-vpn-gw-01"
  network = google_compute_network.gcp-network-01.id
}

# on-prem nw vpn gw

resource "google_compute_ha_vpn_gateway" "on-prem-vpn-nw-01" {
  region = "us-central1"
  name = "on-prem-vpn-gw-01"
  network = google_compute_network.onprem-network-01.id
}

# gcp router

resource "google_compute_router" "gcp-nw-router-01" {
  name = "gcp-nw-router-01"
  region = "us-central1"
  network = google_compute_network.gcp-network-01.id
  bgp {
    asn = 65001
  }
}

# on-prem router

resource "google_compute_router" "onprem-nw-router-01" {
  name = "on-prem-nw-router-01"
  region = "us-central1"
  network = google_compute_network.onprem-network-01.id
  bgp {
    asn = 65002
  }
}

#GCP - tunnels

#Tunnel-1

resource "google_compute_vpn_tunnel" "gcp-tunnel-to-onprem-01" {
  name = "gcp-tunnel-to-onprem-01"
  region = "us-central1"
  vpn_gateway = google_compute_ha_vpn_gateway.gcp-nw-vpn-gw-01.id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.on-prem-vpn-nw-01.id
  shared_secret = "google2024"
  router = google_compute_router.gcp-nw-router-01.id
  vpn_gateway_interface = 0
}

# Tunnel 2

resource "google_compute_vpn_tunnel" "gcp-tunnel-to-onprem-02" {
  name = "gcp-tunnel-to-onprem-02"
  region = "us-central1"
  vpn_gateway = google_compute_ha_vpn_gateway.gcp-nw-vpn-gw-01.id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.on-prem-vpn-nw-01.id
  shared_secret = "google2024"
  router = google_compute_router.gcp-nw-router-01.id
  vpn_gateway_interface = 1
}

#On-prem - tunnels

#tunnel-1

resource "google_compute_vpn_tunnel" "on-prem-to-gcp-tunnel-01" {
  name = "on-prem-to-gcp-tunnel-01"
  region = "us-central1"
  vpn_gateway = google_compute_ha_vpn_gateway.on-prem-vpn-nw-01.id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.gcp-nw-vpn-gw-01.id
  shared_secret = "google2024"
  router = google_compute_router.onprem-nw-router-01.id
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "on-prem-to-gcp-tunnel-02" {
  name = "on-prem-to-gcp-tunnel-02"
  region = "us-central1"
  vpn_gateway = google_compute_ha_vpn_gateway.on-prem-vpn-nw-01.id
  peer_gcp_gateway = google_compute_ha_vpn_gateway.gcp-nw-vpn-gw-01.id
  shared_secret = "google2024"
  router = google_compute_router.onprem-nw-router-01.id
  vpn_gateway_interface = 1
}



#router interfaces#-----

#GCP -router - interfaces

#interface-01

resource "google_compute_router_interface" "gcp-router-int-1" {
  name         = "gcp-router-int-1"
  region       = "us-central1"
  ip_range     = "169.254.0.1/30"
  router = "gcp-nw-router-01"
  vpn_tunnel   = google_compute_vpn_tunnel.gcp-tunnel-to-onprem-01.id
}

#peer - 1.1

resource "google_compute_router_peer" "bgp-peer-on-prem-1-1" {
  name = "bgp-peer-on-prem-1-1"
  region = "us-central1"
  router = "gcp-nw-router-01"
  peer_ip_address = "169.254.0.2"
  peer_asn = 65002
  advertised_route_priority = 100
  interface = google_compute_router_interface.gcp-router-int-1.id
}


#interface-02
resource "google_compute_router_interface" "gcp-router-int-2" {
  name         = "gcp-router-int-2"
  region       = "us-central1"
  ip_range     = "169.254.1.1/30"
  router = "gcp-nw-router-01"
  vpn_tunnel   = google_compute_vpn_tunnel.gcp-tunnel-to-onprem-02.id
}

#peer-2-2

resource "google_compute_router_peer" "bgp-peer-gcp-on-prem-2-2" {
  name = "bgp-peer-gcp-on-prem-2-2"
  region = "us-central1"
  router = "gcp-nw-router-01"
  peer_ip_address = "169.254.1.2"
  peer_asn = 65002
  advertised_route_priority = 100
  interface = google_compute_router_interface.gcp-router-int-2.id
}


#onprem -router - interfaces

#interface-01

resource "google_compute_router_interface" "on-prem-int-01" {
  name = "on-prem-int-01"
  region = "us-central1"
  ip_range = "169.254.0.2/30"
  router = "on-prem-nw-router-01"
  vpn_tunnel = google_compute_vpn_tunnel.on-prem-to-gcp-tunnel-01.id
}

# peer 1-2

resource "google_compute_router_peer" "bgp-peer-onprem-gcp-1-1" {
  name = "bgp-peer-onprem-gcp-1-1"
  region = "us-central1"
  router = "on-prem-nw-router-01"
  peer_ip_address = "169.254.0.1"
  peer_asn = 65001
  advertised_route_priority = 100
  interface = google_compute_router_interface.on-prem-int-01.id
}

#interface-02

resource "google_compute_router_interface" "on-prem-int-02" {
  name = "on-prem-int-02"
  region = "us-central1"
  ip_range = "169.254.1.2/30"
  router = "on-prem-nw-router-01"
  vpn_tunnel = google_compute_vpn_tunnel.on-prem-to-gcp-tunnel-02.id
}

#peer 2-2

resource "google_compute_router_peer" "bgp-peer-onprem-gcp-2-2" {
  name = "bgp-peer-onprem-gcp-2-2"
  region = "us-central1"
  router = "on-prem-nw-router-01"
  peer_ip_address = "169.254.1.1"
  peer_asn = 65001
  advertised_route_priority = 100
  interface = google_compute_router_interface.on-prem-int-02.id
}