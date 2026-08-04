# 1. Service Account for VM
resource "google_service_account" "vm_sa" {
  account_id   = "video-queue-monitor-sa"
  display_name = "Video Queue Monitor Service Account"
}

resource "google_project_iam_member" "metric_writer" {
  project = "terraform-learning-503012"
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_project_iam_member" "log_writer" {
  project = "terraform-learning-503012"
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

# 2. Compute Engine Instance (Task 2)
resource "google_compute_instance" "video_queue_monitor" {
  name         = "video-queue-monitor"
  machine_type = "e2-medium"
  zone         = "us-west4-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      mkdir -p /work/go
      cd /work/go
      
      export PROJECT_ID="terraform-learning-503012"
      export ZONE="us-west4-a"
      export INSTANCE_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/id" -H "Metadata-Flavor: Google")

      cat << 'GOSCRIPT' > main.go
      package main
      import (
          "context"
          "fmt"
          "time"
          monitoring "cloud.google.com/go/monitoring/apiv3/v2"
          monitoringpb "google.golang.org/genproto/googleapis/monitoring/v3"
      )
      func main() {
          fmt.Println("Queue monitor app starting...")
          for {
              time.Sleep(60 * time.Second)
          }
      }
      GOSCRIPT
    EOT
  }
}

# 3. Log-Based Metric (Task 3)
resource "google_logging_metric" "high_res_video_metric" {
  name   = "high_resolution_video_uploads"
  filter = "textPayload=~\"file_format\\\\: ([4,8]K).*\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    display_name = "High Resolution Video Uploads"
  }
}

# 4. Monitoring Dashboard (Task 1 & Task 4)
resource "google_monitoring_dashboard" "media_dashboard" {
  dashboard_json = jsonencode({
    displayName = "Media_Dashboard"
    gridLayout = {
      columns = "2"
      widgets = [
        {
          title = "Video Input Queue Size"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"custom.googleapis.com/opencensus/my.videoservice.org/measure/input_queue_size\" resource.type=\"gce_instance\""
                  }
                }
              }
            ]
          }
        },
        {
          title = "High Resolution Video Upload Rate"
          xyChart = {
            dataSets = [
              {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"logging.googleapis.com/user/high_resolution_video_uploads\""
                  }
                }
              }
            ]
          }
        }
      ]
    }
  })
}

# 5. Alert Policy (Task 5)
resource "google_monitoring_alert_policy" "high_res_upload_alert" {
  display_name = "High Resolution Video Upload Rate Alert"
  combiner     = "OR"
  conditions {
    display_name = "High Res Upload Rate Exceeded"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/high_resolution_video_uploads\" resource.type=\"global\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}
