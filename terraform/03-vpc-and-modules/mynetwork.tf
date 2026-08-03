# 1. יצירת הרשת האוטומטית (VPC)
resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = true
}

# 2. הגדרת חומת האש המאפשרת תעבורת HTTP, SSH, RDP ו-ICMP
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name    = "mynetwork-allow-http-ssh-rdp-icmp"
  network = google_compute_network.mynetwork.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# 3. שרת ראשון דרך המודול (באזור us-east1-b)
module "mynet-vm-1" {
  source           = "./instance"
  instance_name    = "mynet-vm-1"
  instance_zone    = "us-east1-b"
  instance_network = google_compute_network.mynetwork.self_link
}

# 4. שרת שני דרך המודול (באזור us-east1-c)
module "mynet-vm-2" {
  source           = "./instance"
  instance_name    = "mynet-vm-2"
  instance_zone    = "us-east1-c"
  instance_network = google_compute_network.mynetwork.self_link
}