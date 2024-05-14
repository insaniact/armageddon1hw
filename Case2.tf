# Configuration options
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  
  project = "meta-origin-418619"
  credentials = "meta-origin-418619-70e77aa9af3c.json"
  zone = "europe-southwest1-a"
  region = "europe-southwest1"  
}

# Create a VPC network
resource "google_compute_network" "priv-net1" {
  name = "priv-net1"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC network
resource "google_compute_subnetwork" "priv-sub1" {
  name = "private-subnet"
  ip_cidr_range = "10.0.0.0/16" # RFC 1918 Private 10 net #10.0.0.0/24?
  network = google_compute_network.priv-net1.self_link
  region = "europe-southwest1"  # Same region as the VPC network
}

# Create a firewall rule to block all incoming traffic from the internet
resource "google_compute_firewall" "priv-fw1" {
  name = "priv-fw1"
  network = google_compute_network.priv-net1.self_link

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a GCP instance within the private subnet
resource "google_compute_instance" "priv-inst1" {
  name = "priv-inst1"
  machine_type = "e2-medium"
  zone = "europe-southwest1-a"  # Choose appropriate zone in Europe

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.priv-sub1.self_link
    access_config {}
  }
}