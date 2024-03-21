# Configuring Variables for GCP Infrastructure
To deploy your infrastructure on Google Cloud Platform (GCP) using Terraform, you need to specify several important variables. These variables include your GCP project ID, the region where your resources will be deployed, and the name of the Virtual Private Cloud (VPC) network.

## Variable Definitions
- **project_id**: Your unique identifier for the GCP project where the resources will be deployed.

- **region**: The GCP region where your resources will be located. Regions are specific geographic locations where your resources are hosted.
  
- **network_name**: The name of the VPC network where your resources will reside. This should be specified in a global context for the project.

  ### How to Specify Variables
  You can set these variables in several ways:

1. **Terraform CLI Arguments**:
- Use the -var or -var-file arguments when running terraform apply or terraform plan. For example:

    terraform apply -var="project_id=your-project-id" -var="region=us-central1"

2. **Terraform.tfvars File**:
- Create a file named terraform.tfvars in the same directory as your Terraform configuration files, and specify the variable values there. For example:

    project_id = "your-project-id"

    region     = "us-central1"

3. You can simply wait for CLI to ask you :)

Variable Descriptions

 - **project_id**: Insert the project ID provided by GCP. This is required to deploy resources under your specific GCP project.
 
 - **region**: Choose a region that supports the resources you plan to deploy, such as us-central1 or europe-west1.
 
 - **network_name**: If you have an existing VPC network you wish to use, specify its name here. The default is set to a sample network name, but you should replace it with the actual name of your VPC network in GCP.
 - 
