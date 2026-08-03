output "vm_public_ip" {
  value       = google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip
  description = "The public IP of the web server"
}