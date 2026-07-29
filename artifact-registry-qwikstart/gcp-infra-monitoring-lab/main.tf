provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# 1. יצירת רשת VPC ייעודית כדי שלא נשתמש ב-Default
resource "google_compute_network" "lab_vpc" {
  name                    = "lab-monitoring-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lab_subnet" {
  name          = "lab-monitoring-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.lab_vpc.id
}

# 2. הקמת Cloud Router ו-NAT כדי לאפשר למכונה הפרטית להוריד את כלי ה-stress מהאינטרנט
resource "google_compute_router" "router" {
  name    = "lab-router"
  region  = var.region
  network = google_compute_network.lab_vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "lab-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# 3. יצירת שרת VM פרטי עם Startup Script שמייצר עומס
resource "google_compute_instance" "monitored_vm" {
  name         = "lab-monitored-server"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab_subnet.id
    # שים לב: אין כאן access_config, כלומר למכונה אין IP ציבורי בכלל! היא מוגנת.
  }

  labels = {
    environment = "lab"
  }

  # סקריפט התקנה והרצת עומס: מתקין stress ומריץ אותו על המעבד למשך 10 דקות
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y stress
    # מריץ stress על מעבד אחד למשך 600 שניות (10 דקות) כדי להקפיץ את ה-CPU ל-100%
    stress --cpu 1 --timeout 600s
  EOT
}

# 4. יצירת ערוץ התרעות מסוג אימייל
resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Lab Engineering Alerts"
  type         = "email"
  labels = {
    email_address = var.alert_email
  }
}

# 5. יצירת פוליסת התרעה על ניצול CPU גבוה
resource "google_monitoring_alert_policy" "cpu_alert_policy" {
  display_name = "High CPU Usage Alert - Lab VM"
  combiner     = "OR"
  
  conditions {
    display_name = "CPU utilization > 20%"
    
    condition_threshold {
      # הפילטר המעודכן - מנטר כל מכונת Compute Engine בפרויקט
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
      duration        = "0s"      # שינוי ל-0 שניות לתגובה מיידית
      comparison      = "COMPARISON_GT"
      threshold_value = 0.2       # שינוי ל-20% ניצול מעבד
      
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email_channel.name
  ]

  documentation {
    content   = "The Lab Server hosting 'lab-monitored-server' has exceeded 80% CPU utilization due to a stress test simulation."
    mime_type = "text/markdown"
  }
}