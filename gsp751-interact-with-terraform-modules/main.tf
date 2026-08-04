terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

provider "google" {
  project = "terraform-learning-503012"
  region  = "us-west4"
}

resource "random_id" "bucket_prefix" {
  byte_length = 4
}

module "website_bucket" {
  source     = "./modules/gcs-static-website-bucket"
  name       = "demo-website-bucket-${random_id.bucket_prefix.hex}"
  project_id = "terraform-learning-503012"
  location   = "us-west4"
}
