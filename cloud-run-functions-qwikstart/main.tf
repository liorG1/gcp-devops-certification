# רשימת ה-APIs שצריך להפעיל בפרויקט
variable "gcp_services" {
  type        = list(string)
  default     = [
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

# הפעלת ה-APIs אוטומטית
resource "google_project_service" "gcp_services" {
  for_each           = toset(var.gcp_services)
  project            = "terraform-learning-503012"
  service            = each.key
  disable_on_destroy = false
}



provider "google" {
  project = "terraform-learning-503012"
  region  = "us-west4"
  zone    = "us-west4-a"
}

# יצירת באקט זמני לאחסון קוד הפונקציה
resource "google_storage_bucket" "bucket" {
  name     = "terraform-learning-503012-functions-bucket"
  location = "us-west4"
  uniform_bucket_level_access = true
}

# כיווץ התיקייה כולה (כולל ה-package.json החדש)
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = path.module
  excludes    = [".terraform", ".terraform.lock.hcl", "main.tf", "terraform.tfstate", "terraform.tfstate.backup", "function-source.zip"]
  output_path = "${path.module}/function-source.zip"
}

# העלאת הקוד המכווץ לבאקט
resource "google_storage_bucket_object" "object" {
  name   = "function-source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function_zip.output_path
}

# יצירת Cloud Run Function (דור שני)
resource "google_cloudfunctions2_function" "function" {
depends_on = [time_sleep.wait_30_seconds] # ממתין לסיום ה-30 שניות
  
  name        = "gcfunction"
  location    = "us-west4"
  description = "Cloud Run Function - Qwik Start"
  build_config {
    runtime     = "nodejs20"
    entry_point = "helloHttp"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 5
    available_memory   = "256M"
    timeout_seconds    = 60
    ingress_settings   = "ALLOW_ALL"
  }
}

# יצירת השהיה של 30 שניות כדי לאפשר ל-APIs להתעדכן בענן
resource "time_sleep" "wait_30_seconds" {
  depends_on = [google_project_service.gcp_services]
  create_duration = "30s"
}

# מתן גישה ציבורית לפונקציה (Allow public access כפי שנדרש במעבדה)
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloudfunctions2_function.function.location
  project  = google_cloudfunctions2_function.function.project
  service  = google_cloudfunctions2_function.function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# הדפסת ה-URL של הפונקציה בסיום
output "function_url" {
  value = google_cloudfunctions2_function.function.url
}