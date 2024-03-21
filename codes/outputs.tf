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

resource "google_service_account" "readonly_user" {
  account_id   = "readonly-user"
  display_name = "Read Only User"
}

resource "google_project_iam_binding" "project_viewer" {
  project = var.project_id
  role    = "roles/viewer"

  members = [
    "serviceAccount:${google_service_account.readonly_user.email}",
  ]
}

resource "google_project_iam_binding" "compute_instance_creator" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.readonly_user.email}",
  ]
}
