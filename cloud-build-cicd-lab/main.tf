terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# יצירת מאגר ל-Docker Images
resource "google_artifact_registry_repository" "my_repo" {
  location      = var.region
  repository_id = "devops-lab-images"
  description   = "Docker repository for DevOps CI/CD Lab"
  format        = "DOCKER"
}

output "repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my_repo.repository_id}"
}