output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "out_vpc_name" {
  value = google_compute_network.vpc.name
}

output "out_restricted_id" {
  value = google_compute_subnetwork.restricted.id
}

output "out_restricted_name" {
  value = google_compute_subnetwork.restricted.name
}


