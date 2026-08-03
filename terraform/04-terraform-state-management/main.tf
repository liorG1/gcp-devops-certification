provider "google" {
  project     = "terraform-learning-503012"
  region      = "us-central1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name                        = "terraform-learning-503012-tf-state"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true # <-- מוודא שכל התוכן יימחק יחד עם הבאקט
}

terraform {
  backend "gcs" {
    bucket  = "terraform-learning-503012-tf-state"
    prefix  = "terraform/state"
  }
}