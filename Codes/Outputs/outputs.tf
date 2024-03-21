output "instance_name_1" {
  value = google_compute_instance.vm_instance[0].name
}

output "instance_ip_1" {
  value = google_compute_instance.vm_instance[0].network_interface[0].network_ip
}

output "instance_name_2" {
  value = google_compute_instance.vm_instance[1].name
}

output "instance_ip_2" {
  value = google_compute_instance.vm_instance[1].network_interface[0].network_ip
}
