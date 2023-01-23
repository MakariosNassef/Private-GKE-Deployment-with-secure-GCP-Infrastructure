output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "restricted_id" {
  value = google_compute_subnetwork.restricted.id
}

# output "restricted_name" {
#   value = google_compute_subnetwork.restricted.name
# }

# output "istance_id" {
#   value = google_compute_instance.nat.id
# }



