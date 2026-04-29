# Generate a random name for the GCS bucket to avoid naming conflicts
resource "random_pet" "gcs_bucket_name" {
  prefix = "tf-gcs-bucket"
  length = 2
}

# Create a GCS (Google Cloud Storage) bucket
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket.html
resource "google_storage_bucket" "gcs_bucket" {
  name                        = random_pet.gcs_bucket_name.id
  location                    = "us-central1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true # GCP organization has a policy that requires uniform bucket-level access

  labels = {
    deployment  = "terraform"
    environment = "dev"
  }
}

# Upload a sample image to the GCS bucket
resource "google_storage_bucket_object" "sample_image" {
  bucket = google_storage_bucket.gcs_bucket.name
  source = "${path.module}/sample_image.png" # path to the local file to upload
  name   = "sample_image.png" # name of the object in the bucket
}
