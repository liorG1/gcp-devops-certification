terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# דלי Cloud Storage שמשמש לאחסון ה-State בענן
resource "google_storage_bucket" "test_bucket_for_state" {
  name                        = "${var.project_id}-state-bucket-gsp752"
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true

  labels = {
    environment = "dev"
    managed_by  = "terraform"
    lab         = "gsp752"
  }
}