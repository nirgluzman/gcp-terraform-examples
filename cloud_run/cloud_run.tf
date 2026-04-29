# Deploy a publicly accessible Cloud Run service running a hello-world container.

# Create the Cloud Run service.
resource "google_cloud_run_v2_service" "cloudrun_service" {
  name                = "cloudrun-service"
  location            = "us-central1"
  deletion_protection = false          # allow terraform destroy to delete the service
  ingress             = "INGRESS_TRAFFIC_ALL" # allow all inbound traffic to reach the service

  scaling {
    max_instance_count = 1 # limit to 1 instance to control costs
  }

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" # sample hello-world container image
    }
  }
}

# Grant public unauthenticated access to invoke the Cloud Run service.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam
#
# NOTE: allUsers may be blocked by org policy (constraints/iam.allowedPolicyMemberDomains)
# If so, replace allUsers with a specific user: "user:<email>" or serviceAccount
resource "google_cloud_run_v2_service_iam_binding" "public_access" {
  name     = google_cloud_run_v2_service.cloudrun_service.name
  location = google_cloud_run_v2_service.cloudrun_service.location
  role     = "roles/run.invoker" # permission required to call the service URL
  members  = ["allUsers"]        # allUsers = anyone on the internet, no auth required
}
