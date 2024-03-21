# Creating Infrastructure with Terraform on GCP
This guide details step-by-step how to use Terraform to create a Virtual Private Cloud (VPC) network, a subnetwork, two Compute Engine instances, a Google Cloud SQL instance, and other related resources on Google Cloud Platform (GCP).

## Prerequisites
1. You must have a Google Cloud account.
2. Terraform must be installed.

## Usage
- In the directory where your Terraform configuration files are located, initialize Terraform:
`terraform init`
- Check the correctness of the configuration and the resources that will be created:
`terraform plan`
- To create the resources, run the Terraform apply command:
`terraform apply`
- After successfully creating the resources, if you want to remove them (They will be completely deleted, it is not recommended to use this unless necessary.):
`terraform destroy`

## Created Resources
This Terraform file automatically creates the following resources on GCP:

- **Google Compute Network (VPC Network)**: A VPC network named 'vpc-network'.
- **Google Compute Subnetwork**: A subnetwork named 'subnet', with specified IP ranges.
- **Google Compute Instance**: Two Compute Engine instances with the prefix 'kartaca-staj'.
- **Google Cloud SQL Instance**: A Cloud SQL instance named 'cloudsql-instance'.
- **Google Cloud Storage Bucket**: A Google Cloud Storage bucket with an appropriate name.
- **Other Related Resources**: Additional resources such as snapshot policies, firewall rules, and a Cloud Run service.
