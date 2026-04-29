# Cloud Function - Terraform

Deploys an HTTP-triggered **Cloud Function (Gen 2)** on GCP using Terraform.

https://docs.cloud.google.com/functions/docs/tutorials/terraform

## Structure

```
cloud_function/
├── src/
│   ├── index.js          # Function source code (echoes request body)
│   └── package.json      # Node.js dependencies
├── providers.tf          # Google & Random provider configuration
├── variables.tf          # Input variables (region)
├── cloud_function.tf     # Core infra: GCS bucket, zip upload, function, public access
├── iam.tf                # IAM roles required for Cloud Build to deploy the function
├── outputs.tf            # Outputs the deployed function URL
└── test.rest             # REST client test for the deployed function URL
```

## File Objectives

| File | Purpose |
|---|---|
| `providers.tf` | Configures the Google Cloud and Random providers |
| `variables.tf` | Defines the deployment region (default: `us-central1`) |
| `cloud_function.tf` | Zips `src/`, uploads to GCS, deploys the Gen 2 function, and makes it publicly invocable |
| `iam.tf` | Grants the Compute service account and Cloud Build service agent the roles needed to build and deploy |
| `outputs.tf` | Outputs the function's HTTPS URL after deployment |
| `test.rest` | REST Client test file to manually test the deployed function |

## Deploy

```bash
terraform init
terraform apply
```

## Authentication

Uses a Service Account key file at `keys.json`. See the root [README](../README.md) for setup instructions.
