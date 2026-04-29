# Terraform providers
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

# Google Cloud provider
provider "google" {
  # Configuration options
  project     = "<your-project-id>"
  region      = var.region
  credentials = "${path.module}/keys.json" # path to Service Account key file
}

# Random provider
provider "random" {
  # Configuration options (if needed)
}
