resource "google_compute_instance" "tf_instance_1" {
  name         = "tf-instance-1"
  machine_type = "e2-standard-2"
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network_self_link
    subnetwork = var.subnet_01_name
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
}

resource "google_compute_instance" "tf_instance_2" {
  name         = "tf-instance-2"
  machine_type = "e2-standard-2"
  zone         = var.zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network_self_link
    subnetwork = var.subnet_02_name
  }

  metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
}