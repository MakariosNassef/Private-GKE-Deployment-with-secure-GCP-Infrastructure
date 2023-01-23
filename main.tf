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

