terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  # Configuration options

  project     = "meta-origin-418619"
  credentials = "meta-origin-418619-70e77aa9af3c.json"
  zone        = "europe-southwest1-a"
  region      = "europe-southwest1"  # Choose a suitable Europe region
}

# Create a VPC network
resource "google_compute_network" "private_network" {
  name                    = "private-network"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC network
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.0.0/16" 
  network       = google_compute_network.private_network.self_link
  region        = "europe-southwest1"  
}

# Create a firewall rule to block all incoming traffic from the internet
resource "google_compute_firewall" "block_internet_access" {
name    = "block-internet-access"
  network = google_compute_network.private_network.self_link

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a GCP instance within the private subnet
resource "google_compute_instance" "private_instance" {
  name         = "private-instance"
  machine_type = "e2-medium"
  zone         = "europe-southwest1-a"  

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.self_link
    access_config {}
  }
}