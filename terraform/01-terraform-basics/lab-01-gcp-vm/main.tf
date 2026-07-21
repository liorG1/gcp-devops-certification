terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "terraform-learning-503012"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "terraform" {
  name         = "terraform"
  machine_type = "e2-medium"
  tags         = ["web", "dev"]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // מייצר IP חיצוני לשרת
    }
  }
  
  allow_stopping_for_update = true
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]
}