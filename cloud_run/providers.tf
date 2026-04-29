# Terraform providers
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
  }
}

# Google Cloud provider
provider "google" {
  # Configuration options
  project     = "<your-project-id>"
  region      = "us-central1"
  credentials = "${path.module}/keys.json" # path to Service Account key file
}
