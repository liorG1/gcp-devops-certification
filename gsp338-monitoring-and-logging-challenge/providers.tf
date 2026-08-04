terraform {
  required_version = ">= 1.0"
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
