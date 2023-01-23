resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "management" {
  name          = var.management-subnet-name
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-east2" #var.region
}
 
resource "google_compute_subnetwork" "restricted" {
  name          = var.restricted-subnet-name
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.2.0/24"
  region        = "asia-east2" #var.region
  private_ip_google_access = true
}
 
resource "google_compute_firewall" "management_subnet_firewall" {
  name    = "management-subnet-firewall"
  network = google_compute_network.vpc.id
  direction = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
  #target_tags = ["management-vm"]
  priority = 100
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

resource "google_compute_address" "nat_ip" {
  name = "nat-ip"
  region = "asia-east2"
}
 
resource "google_compute_instance" "private-management-vm" {
  name         = "private-management-vm"
  machine_type = "f1-micro"
  zone         = "asia-east2-a" #var.region
 
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  metadata = {
  enable-oslogin = "TRUE"
  }
  #tags = ["management-vm"]
  network_interface {
    subnetwork = google_compute_subnetwork.management.id
    access_config {
      nat_ip = google_compute_address.nat_ip.address
    }
  }
}

resource "google_compute_router" "router" {
    name    = "nat-router"
    network = google_compute_network.vpc.id

    bgp {
        asn = 64512
    }
}
