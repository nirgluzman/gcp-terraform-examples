# Grants IAM roles required to deploy Cloud Functions (Gen 2):
# - Compute service account: impersonation and build execution permissions
# - Cloud Build Service Agent: orchestration across Logging, Artifact Registry, and Cloud Run
#
# NOTE:
# Cloud Functions (Gen 2) uses the default Compute service account
# ({project_number}-compute@developer.gserviceaccount.com) as the runtime identity,
# not a dedicated Cloud Functions service account as in Gen 1.

# Get the project number automatically
data "google_project" "project" {}

# Role 1: Allow the Compute service account to be impersonated during builds
resource "google_project_iam_member" "cloudbuild_service_account_user" {
  project = data.google_project.project.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

# Role 2: Allow the Compute service account to run builds and store artifacts
resource "google_project_iam_member" "cloudbuild_builder" {
  project = data.google_project.project.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

# Role 3: Allow the Cloud Build Service Agent to orchestrate the build lifecycle.
# Essential for cross-service communication (Logging, Artifact Registry, Cloud Run) in Gen 2.
resource "google_project_iam_member" "cloudbuild_service_agent" {
  project = data.google_project.project.project_id
  role    = "roles/cloudbuild.serviceAgent"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}
