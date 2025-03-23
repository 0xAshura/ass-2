resource "google_compute_instance" "flask_instance" {
  name         = "limbad-flask-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
    access_config {
      // Public IP assigned
    }
  }

  metadata = {
    "gce-container-declaration" = <<EOF
spec:
  containers:
  - name: flask-app
    image: docker.io/0xashura/flask-app:latest
    ports:
    - containerPort: 5000
EOF
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  tags = ["limbad-flask-app"]
}

resource "google_compute_firewall" "flask_firewall" {
  name    = "limbad-flask-firewall"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["limbad-flask-app"]
}