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
  region  = "us-west4"
  zone    = "us-west4-a"
}

# רשת ברירת מחדל עבור המכונות
data "google_compute_network" "default" {
  name = "default"
}

# מכונה ראשונה (מקבילה ל-Project 1 במעבדה)
resource "google_compute_instance" "instance1" {
  name         = "instance1"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.name
    access_config {
      // Ephemeral IP לצורך גישת אינטרנט/Uptime Check
    }
  }
}

# מכונה שנייה (מקבילה ל-Project 2 במעבדה - משימה 1)
resource "google_compute_instance" "instance2" {
  name         = "instance2"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.google_compute_network.default.name
    access_config {
      // Ephemeral IP
    }
  }
}

# יצירת קבוצת ניטור - Cloud Monitoring Group (משימה 2)
resource "google_monitoring_group" "demo_group" {
  display_name = "DemoGroup"
  filter       = "resource.metadata.name = has_substring(\"instance\")"
}

# יצירת Uptime Check עבור הקבוצה (משימה 3)
resource "google_monitoring_uptime_check_config" "uptime_check" {
  display_name = "DemoGroup uptime check"
  timeout      = "10s"
  period       = "60s" # דקה אחת

  tcp_check {
    port = 22
  }

resource_group {
    group_id      = google_monitoring_group.demo_group.id
    resource_type = "INSTANCE"
  }
}

# יצירת Alert Policy (משימה 4)
resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Uptime Check Policy"
  combiner     = "OR"
  conditions {
    display_name = "Uptime health check on DemoGroup"
    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"gce_instance\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      
      trigger {
        count = 1
      }
    }
  }
}

# יצירת Custom Dashboard (משימה 5)
resource "google_monitoring_dashboard" "custom_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "DemoGroup Metrics Dashboard",
  "gridLayout": {
    "widgets": [
      {
        "title": "VM Instance - Uptime",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"compute.googleapis.com/instance/uptime\" resource.type=\"gce_instance\"",
                  "aggregation": {
                    "perSeriesAligner": "ALIGN_RATE"
                  }
                }
              },
              "plotType": "LINE"
            }
          ]
        }
      }
    ]
  }
}
EOF
}

resource "google_monitoring_notification_channel" "email_channel" {
  display_name = "Email Notification Channel"
  type         = "email"
  
  labels = {
    email_address = "lior.getahun4@gmail.com"
  }
}

resource "google_monitoring_alert_policy" "uptime_alert_policy" {
  display_name = "LAMP Server Uptime Alert Policy"
  combiner     = "OR"
  
  notification_channels = [google_monitoring_notification_channel.email_channel.id]

  conditions {
    display_name = "Uptime Check Failing"

    condition_threshold {
      filter     = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"gce_instance\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields    = ["resource.label.*"]
      }
    }
  }

  documentation {
    content   = "The LAMP server uptime check has failed. Please check the instance status and Apache web server."
    mime_type = "text/markdown"
  }
}