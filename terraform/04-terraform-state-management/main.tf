provider "google" {
  project     = "terraform-learning-503012"
  region      = "us-central1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name                        = "terraform-learning-503012-tf-state" # שם ייחודי גלובלית לבאקט
  location                    = "US"
  uniform_bucket_level_access = true
}

terraform {
  backend "gcs" {
    bucket  = "terraform-learning-503012-tf-state"
    prefix  = "terraform/state"
  }
}