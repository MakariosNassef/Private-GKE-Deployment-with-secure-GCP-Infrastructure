resource "google_container_cluster" "private-cluster" {
  name     = "private-cluster"
  location = "asia-east2-a"
  network = var.network_vpc_name
  subnetwork = var.sub_network_name
  release_channel {
    channel = "REGULAR"
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {
    # cluster_ipv4_cidr_block = "192.168.0.0/16"
    # services_ipv4_cidr_block = "10.96.0.0/16" 
  }
  # only management subnet can access
  master_authorized_networks_config {
    cidr_blocks {
      display_name = "management-subnet"
      cidr_block = "10.0.1.0/24"
    }
  }
}



# node pool collection of nodes in GCP
resource "google_container_node_pool" "private-cluster-node-pool" {
  name       = "private-cluster-node-pool"
  location   = "asia-east2-a"
  cluster    = google_container_cluster.private-cluster.name
  node_count = 1

  # upgrade_settings {
  #   max_surge       = 1
  #   max_unavailable = 0
  # }

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_type    = "pd-standard"
    disk_size_gb = 10
    image_type   = "ubuntu_containerd"
    service_account = google_service_account.gke-cluster-service.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"

    ]
  }
}