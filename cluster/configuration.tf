resource "google_service_account" "gke-cluster-service" {
  account_id   = "gke-cluster-service"
  display_name = "gke-cluster-service"
}

resource "google_project_iam_member" "example_binding" {
  project = "iti-makarios"
  role    = "roles/storage.objectViewer"
  #role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke-cluster-service.email}"
}

# resource "google_project_iam_member" "obj_example_binding" {
#   project = "iti-makarios"
#   role    = "roles/storage.objectAdmin"
#   member  = "serviceAccount:${google_service_account.gke-cluster-service.email}"
# }



