resource "google_compute_network" "americas_network" {
  name = "americas-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "americas_subnet1" {
  name          = "americas-subnet1"
  region        = "southamerica-east1"
  network       = google_compute_network.americas_network.self_link
  ip_cidr_range = "172.16.1.0/24"
}

resource "google_compute_subnetwork" "americas_subnet2" {
  name          = "americas-subnet2"
  region        = "southamerica-west1"
  network       = google_compute_network.americas_network.self_link
  ip_cidr_range = "172.16.2.0/24"
}

resource "google_compute_firewall" "americas_firewall" {
  name    = "americas-firewall"
  network = google_compute_network.americas_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"] 
}