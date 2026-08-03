# 1. התראה על CPU גבוה עבור שרתי הפרונטאנד (שני ה-Workers)
resource "google_monitoring_alert_policy" "cpu_alert_policy" {
  display_name = "High CPU Utilization - Frontend Servers"
  combiner     = "OR"
  
  conditions {
    display_name = "CPU usage greater than 80% for 5 minutes"
    
    condition_threshold {
      # פילטר נקי וממוקד לכל מכונות ה-Compute Engine ב-Scope
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\"" 
      duration        = "300s" # 5 דקות
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8 # 80%
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  documentation {
    content   = "The CPU utilization on a frontend worker instance has exceeded 80% for over 5 minutes. Please check the instance health."
    mime_type = "text/markdown"
  }
}
# 2. התראה על שרת למטה (Uptime) עבור סביבת הטסט (Worker 2)
resource "google_monitoring_alert_policy" "uptime_alert_policy" {
  display_name = "Server Down - Test Environment"
  combiner     = "OR"

  conditions {
    display_name = "Instance uptime is missing or zero"

    condition_threshold {
      # שימוש במטריקת uptime ופילטור ספציפי לפי הלייבל stage=test ששמנו על Worker 2
      filter          = "metric.type=\"compute.googleapis.com/instance/uptime\" AND resource.type=\"gce_instance\""
      duration        = "60s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1.0 # פחות מ-1 שניה (כלומר, השרת כבוי/לא מגיב)

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }

  documentation {
    content   = "The test environment server (Worker 2) is down or failing to report uptime metrics. Check the VM instance state immediately."
    mime_type = "text/markdown"
  }
}