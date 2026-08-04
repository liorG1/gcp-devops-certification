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
  region  = "us-west4"
  zone    = "us-west4-a"
}

# VPC Network Resource
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# Static IP Address
resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

# Compute Instance Resource
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  provisioner "local-exec" {
    command = "echo ${self.name}: ${self.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }
}