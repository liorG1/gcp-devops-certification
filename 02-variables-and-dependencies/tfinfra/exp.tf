resource "google_storage_bucket" "example_bucket" {
  name          = "liorg1-terraform-bucket-503012"
  location      = "US"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "another_instance" {
  name         = "terraform-instance-2"
  machine_type = "e2-micro"
  zone         = var.instance_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  depends_on = [google_storage_bucket.example_bucket]
}