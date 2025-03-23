resource "google_compute_network" "vpc" {
  name                    = "limbad-flask-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "limbad-public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc.id
  region        = "us-central1"
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "limbad-private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.vpc.id
  region        = "us-central1"
}