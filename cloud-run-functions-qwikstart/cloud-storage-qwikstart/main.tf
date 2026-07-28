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
}

# Task 1: יצירת ה-Bucket
resource "google_storage_bucket" "my_bucket" {
  name          = "terraform-learning-503012-bucket" # שם ייחודי גלובלי
  location      = "us-west4"
  storage_class = "STANDARD"

  # ביטול חסימת גישה ציבורית (אנלוגי לכיבוי Enforce public access prevention)
  public_access_prevention = "inherited" 
  
  # הגדרה של Uniform access control
  uniform_bucket_level_access = true

  # מחיקה מהירה של הבאקט כולל מה שבתוכו בסיום המעבדה
  force_destroy = true 
}

# Task 3: הפיכת הבאקט/אובייקטים לציבוריים (Storage Object Viewer לכל העולם)
resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.my_bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

# הדפסת הקישור הציבורי של הקובץ בסיום הריצה
output "public_kitten_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.my_bucket.name}/kitten.png"
}