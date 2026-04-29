# Cloud Function - HTTP-triggered Node.js function deployed via GCS source
# https://docs.cloud.google.com/functions/docs/tutorials/terraform

# Generate a random name for the GCS bucket to avoid naming conflicts
resource "random_pet" "gcs_bucket_name" {
  prefix = "tf-gcf-source"
  length = 2
}

# Zip the src folder
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function.zip"
}

# GCS bucket to store the zip
resource "google_storage_bucket" "function_bucket" {
  name                        = "${random_pet.gcs_bucket_name.id}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
}

# Upload zip to GCS
resource "google_storage_bucket_object" "function_zip" {
  name   = "function-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_zip.output_path
}

# Cloud Function
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function
resource "google_cloudfunctions2_function" "function" {
  name     = "hello-world"
  location = var.region

  # prevents a race condition by ensuring IAM permissions propagate before the build starts.
  depends_on = [
    google_project_iam_member.cloudbuild_service_account_user,
    google_project_iam_member.cloudbuild_builder
  ]

  build_config {
    runtime     = "nodejs22"
    entry_point = "helloWorld"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "128Mi"
    timeout_seconds    = 60
  }
}

# Make the function public
resource "google_cloud_run_v2_service_iam_binding" "public_access" {
  name     = google_cloudfunctions2_function.function.name
  location = google_cloudfunctions2_function.function.location
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}
