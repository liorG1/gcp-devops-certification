provider "google" {
  project = "terraform-learning-503012"
  region  = "us-west4"
  zone    = "us-west4-a"
}

# 1. יצירת ה-VM עם התקנה אוטומטית של Apache
resource "google_compute_instance" "lamp_vm" {
  name         = "lamp-1-vm"
  machine_type = "e2-medium"
  zone         = "us-west4-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // מייצר IP חיצוני (External IP)
    }
  }

  # הרצת סקריפט התקנה ל-Apache מיד עם עליית השרת
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2
  EOT
}

# 2. פתיחת תעבורת HTTP (פורט 80) ב-Firewall
resource "google_compute_firewall" "http_server" {
  name    = "default-allow-http-monitoring"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# 3. יצירת Uptime Check עבור ה-VM
resource "google_monitoring_uptime_check_config" "http_check" {
  display_name = "Lamp Uptime Check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path = "/"
    port = "80"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "terraform-learning-503012"
      host       = google_compute_instance.lamp_vm.network_interface[0].access_config[0].nat_ip
    }
  }
}

output "vm_external_ip" {
  value = google_compute_instance.lamp_vm.network_interface[0].access_config[0].nat_ip
}