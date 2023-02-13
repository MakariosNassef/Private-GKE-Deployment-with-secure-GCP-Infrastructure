resource "google_service_account" "mac-service-account" {
  project = "iti-makarios"
  account_id = "macz-acc-22"
  display_name = "Makarios Nassef"
}

resource "google_project_iam_member" "example_binding" {
  project = "iti-makarios"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.mac-service-account.email}"
}



