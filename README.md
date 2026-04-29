# GCP Terraform Examples

### Resources

- [HashiCorp Terraform provider for Google Cloud](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Udemy Course - Terraform with GCP by Ankit Mistry](https://www.udemy.com/course/terraform-for-beginners-using-google-cloud)

## Examples

| Example | Description |
|---|---|
| `cloud_storage/` | Creates a GCS bucket with a random name and uploads a sample image |
| `cloud_run/` | Deploys a public hello-world container on Cloud Run with a single instance |
| `cloud_function/` | Deploys an HTTP-triggered Cloud Function (Gen 2) that returns the request method and body |

## Authenticate with GCP
1. [gcloud auth application-default login](https://docs.cloud.google.com/sdk/gcloud/reference/auth/application-default/login)
Create a local file to authenticate local code, tools (e.g., Terraform), or IDEs (e.g., VS Code) with Google Cloud APIs.

2. Service Account keys - preferred in production:
- Create a Service Account in the GCP Console.
- Assign appropriate roles (e.g., Editor, Owner, or custom roles).
- Create and download a JSON key file for the Service Account.
- Use the JSON key file to authenticate Terraform by specifying the path in the provider configuration (e.g., `credentials = "${path.module}/keys.json"`).
