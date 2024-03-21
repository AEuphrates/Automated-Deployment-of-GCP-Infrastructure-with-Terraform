terraform {
  required_version = ">= 0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric  = true
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "subnet-${random_string.suffix.result}"
  region                   = var.region
  network                  = google_compute_network.vpc_network.self_link
  ip_cidr_range            = "10.100.0.0/23"
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "gke-pod-range"
    ip_cidr_range = "10.100.64.0/18"
  }
  secondary_ip_range {
    range_name    = "gke-service-range"
    ip_cidr_range = "10.100.128.0/20"
  }
}

resource "google_compute_disk" "data_disk" {
  count = 2
  name  = "data-disk-${count.index}-${random_string.suffix.result}"
  type  = "pd-standard"
  zone  = "europe-west1-c"
  size  = 20
}

resource "google_compute_instance" "vm_instance" {
  count        = 2
  name         = "kartaca-staj-${count.index + 1}-${random_string.suffix.result}"
  machine_type = "e2-medium"
  zone         = "europe-west1-c"
  deletion_protection = false
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 16
    }
  }

  attached_disk {
    source = google_compute_disk.data_disk[count.index].self_link
  }

  network_interface {
   network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    network_ip = cidrhost(google_compute_subnetwork.subnet.ip_cidr_range, count.index + 4)
  }

  tags = ["kartaca-staj"]

  service_account {
    scopes = ["cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

resource "google_compute_resource_policy" "snapshot_policy" {
  name   = "autosnap-${random_string.suffix.result}"
  region = "europe-west1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "03:00"
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      storage_locations = ["eu"]
    }
  }
}

resource "google_compute_firewall" "ssh_access" {
  name    = "ssh-access-${random_string.suffix.result}"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kartaca-staj"]
}

resource "google_compute_router" "router" {
  name    = "router-${random_string.suffix.result}"
  region  = var.region
  network = google_compute_network.vpc_network.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-${random_string.suffix.result}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_sql_database_instance" "cloudsql_instance" {
  name             = "cloudsql-instance-${random_string.suffix.result}"
  project          = var.project_id
  region           = "europe-west1"
  database_version = "MYSQL_8_0"
  deletion_protection = false
  settings {
    tier            = "db-custom-2-7680"
    disk_size       = 10
    disk_autoresize = true
    disk_type       = "PD_SSD"

    backup_configuration {
      enabled            = true
      binary_log_enabled = true 
      start_time         = "03:00"
    }

    maintenance_window {
      day          = 6  
      hour         = 4  
      update_track = "stable"
    }
  }
}



resource "google_sql_database" "database" {
  name     = "kartaca"
  instance = google_sql_database_instance.cloudsql_instance.name
}

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}

resource "google_sql_user" "user" {
  name     = "kartaca-user"
  instance = google_sql_database_instance.cloudsql_instance.name
  password = random_string.suffix.result
}

resource "google_secret_manager_secret" "app_secret" {
  project   = var.project_id
  secret_id = "app-secret-${random_string.suffix.result}"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret" "db_secret" {
  project   = var.project_id
  secret_id = "db-secret-${random_string.suffix.result}"
  

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "db_secret_version" {
  secret      = google_secret_manager_secret.db_secret.id
  secret_data = base64encode(random_string.suffix.result)
}

resource "google_cloud_run_service" "default" {
  name     = "example-service-${random_string.suffix.result}"
  location = var.region
  project  = var.project_id

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"

        env {
          name  = "APP_SECRET_PATH"
          value = "/secrets/app_secret"
        }

        env {
          name  = "DB_SECRET_PATH"
          value = "/secrets/db_secret"
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_vpc_access_connector" "serverless_connector" {
  name          = "serverless-connector"
  region        = "europe-west1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.8.0.0/28"
  min_throughput = 200
  max_throughput = 300
}

resource "google_container_cluster" "gke_cluster" {
  name               = "gke-cluster-${random_string.suffix.result}"
  location           = "europe-west1-c"
  initial_node_count = 1

  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  release_channel {
    channel = "RAPID"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pod-range"
    services_secondary_range_name = "gke-service-range"
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }


  master_authorized_networks_config {
    
    cidr_blocks {
      cidr_block   = "203.0.113.0/24" 
      display_name = "My Office Network"
    }
  }
}
