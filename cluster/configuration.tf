resource "google_service_account" "gke-cluster-service" {
  account_id   = "gke-cluster-service"
  display_name = "gke-cluster-service"
}

resource "google_project_iam_member" "example_binding" {
  project = "iti-makarios"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke-cluster-service.email}"
}



