output "network_IP" {
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
  description = "The internal ip address of the instance"
}

output "instance_link" {
  value       = google_compute_instance.vm_instance.self_link
  description = "The URI of the created resource."
}

output "another_instance_link"{
    value = google_compute_instance.another_instance.self_link
    description = "Info about second mechine"
}