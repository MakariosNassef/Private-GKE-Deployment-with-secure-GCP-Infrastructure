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
  target_tags = ["management-vm"]
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
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  metadata = {
  enable-oslogin = "TRUE"
  }
  tags = ["management-vm"]
  network_interface {
    subnetwork = google_compute_subnetwork.management.id
    access_config {
      nat_ip = google_compute_address.nat_ip.address
    }
  }
  service_account {
    email = google_service_account.mac-service-account.email
    scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  metadata_startup_script = <<-EOF
    sudo apt-get install  -y apt-transport-https ca-certificates gnupg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud -y
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
    kubectl version --client
    sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
    # sudo USE_GKE_GCLOUD_AUTH_PLUGIN: True
    # gcloud container clusters get-credentials private-cluster --zone asia-east2-a --project iti-makarios
  EOF
}

resource "google_compute_router" "router" {
    name    = "nat-router"
    network = google_compute_network.vpc.id

    bgp {
        asn = 64512
    }
}
