terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "terraform-learning-503012-bucket"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "instances" {
  source            = "./modules/instances"
  project_id        = var.project_id
  region            = var.region
  zone              = var.zone
  network_self_link = module.vpc.network_self_link
  subnet_01_name    = module.vpc.subnets_names[0]
  subnet_02_name    = module.vpc.subnets_names[1]
}

module "storage" {
  source      = "./modules/storage"
  project_id  = var.project_id
  region      = var.region
  zone        = var.zone
  bucket_name = "terraform-learning-503012-bucket"
}

# Task 6: Terraform Registry Network Module
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"

  project_id   = var.project_id
  network_name = "tf-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    }
  ]
}

# Task 7: Firewall Rule
resource "google_compute_firewall" "tf_firewall" {
  name    = "tf-firewall"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}