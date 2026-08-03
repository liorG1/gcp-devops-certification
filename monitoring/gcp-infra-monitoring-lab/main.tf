terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 1. רשת בסיסית (VPC ו-Subnet) עבור השרת
resource "google_compute_network" "vpc_network" {
  name                    = "monitoring-lab-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network_subnet" {
  name          = "monitoring-lab-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# 2. חוק חומת אש המאפשר תעבורת HTTP ו-ICMP (בשביל ה-Uptime Check)
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-and-uptime"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"] # Cloud Monitoring משתמש בטווחים ציבוריים לבדיקה
  target_tags   = ["http-server"]
}

# 3. שרת Compute Engine עם התקנת Apache בסיסית
resource "google_compute_instance" "web_server" {
  name         = "monitoring-lab-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.network_subnet.name
    access_config {
      // מייצר IP ציבורי שנדרש ל-Uptime Check מהאינטרנט
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "Hello from GCP DevOps Lab!" > /var/www/html/index.html
    systemctl restart apache2
  EOT
}

# 4. הגדרת Uptime Check שמודד את תקינות השרת כל דקה
resource "google_monitoring_uptime_check_config" "http_check" {
  display_name = "vm-http-uptime-check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path = "/"
    port = "80"
  }

  monitored_resource {
    type = "uptime_url"
labels = {
      project_id = var.project_id
      host       = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
    }
    
  }
}

# 5. הגדרת Alert Policy - תתריע אם השרת למטה מעל 5 דקות
resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "HTTP Uptime Check Failure Alert"
  combiner     = "OR"
  conditions {
    display_name = "Uptime Check URL - Failing"
    condition_threshold {
filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_FRACTION_TRUE"
      }
    }
  }
}