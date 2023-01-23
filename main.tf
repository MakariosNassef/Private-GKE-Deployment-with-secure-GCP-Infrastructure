provider "google" {
  project     = "iti-makarios"
  region      = "asia-east2"
  credentials = file("/home/mac/.config/gcloud/application_default_credentials.json")
}


module "network_module" {
  source = "./network"
  vpc_name = "my-vpc"
  management-subnet-name = "management-subnet"
  restricted-subnet-name = "restricted-subnet"
}

module "gke_cluster" {
  source = "./cluster"
  network_vpc_name= module.network_module.out_vpc_name
  sub_network_name= module.network_module.out_restricted_name
}
