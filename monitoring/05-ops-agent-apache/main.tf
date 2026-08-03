terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "terraform-learning-503012"
  region  = "us-central1"
  zone    = "us-central1-a"
}

data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https-ops-lab"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_instance" "quickstart_vm" {
  name         = "quickstart-vm"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = data.google_compute_network.default.name
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    sudo apt-get update
    sudo apt-get install -y apache2 php
    curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
    sudo bash add-google-cloud-ops-agent-repo.sh --also-install
    sudo cp /etc/google-cloud-ops-agent/config.yaml /etc/google-cloud-ops-agent/config.yaml.bak

    sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null << 'INNER_EOF'
metrics:
  receivers:
    apache:
      type: apache
  service:
    pipelines:
      apache:
        receivers:
          - apache
logging:
  receivers:
    apache_access:
      type: apache_access
    apache_error:
      type: apache_error
  service:
    pipelines:
      apache:
        receivers:
          - apache_access
          - apache_error
INNER_EOF

    sudo service google-cloud-ops-agent restart
  EOT

  labels = {
    goog-ops-agent = "true"
  }
}

output "instance_external_ip" {
  value       = google_compute_instance.quickstart_vm.network_interface[0].access_config[0].nat_ip
  description = "The external IP of the Apache Web Server"
}
