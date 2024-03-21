# Cloud Infrastructure Automation with Terraform in GCP

This repository contains Terraform configurations for automating cloud infrastructure on Google Cloud Platform (GCP) to showcase the creation of a secure and scalable cloud environment. It leverages Terraform for deploying a series of cloud resources with a focus on best practices for security and scalability. Terraform, an open-source "Infrastructure as Code" tool, is utilized for provisioning and managing cloud infrastructure ranging from VM instances to networking and beyond.

 ## Project Overview
 This project aims to equip cloud engineers with the practical skills to deploy a fully automated, secure, and scalable environment in GCP. By following this guide, you will create a GCP project configured with the following resources, all suffixed with a randomly generated 6-character string to ensure uniqueness:

- A Virtual Private Cloud (VPC) with custom subnetworks
- Compute Engine instances for application deployment
- A Google Kubernetes Engine (GKE) cluster configured for container orchestration
- Cloud SQL instance for relational database services
- Cloud Storage for object storage
- CloudRun for running containerized applications
- Necessary networking components including Cloud Router and NAT Gateway for internet access
- IAM configurations for secure access and operation
- Snapshot policies and Secret Manager for data backup and secret management respectively

## Prequisites
Before starting, ensure you have the following:

- A Google Cloud account
- Terraform
- gcloud CLI installed and configured

## Quick Start
1. Clone this repository to your project.
2. Ensure your Google Cloud SDK is authenticated against the desired account and project.
3. Navigate to the project directory in your terminal.
4. Initialize Terraform with terraform init.
5. Apply the Terraform configuration with terraform apply.
6. Follow the on-screen prompts to deploy the resources.

## Project Structure
1. `main.tf`: The core file that contains the definition of what resources are to be created. It includes the configuration for VPCs, Compute Instances, GKE clusters, Cloud SQL instances, CloudRun services, networking, IAM roles, and more.
    
2. `variables.tf`: Defines the variables used across the configurations, allowing for a modular and reusable codebase. Variables include project ID, region settings, resource sizing, and naming conventions.
    
3. `outputs.tf`: Specifies the output variables that Terraform will print at the end of the deployment process. Outputs typically include IP addresses, DNS names, and other critical information for accessing and managing the deployed resources.

## Outputs
After applying the Terraform configuration, key information about the deployed resources, such as instance names and IP addresses, will be outputted to the console. This information is crucial for accessing and managing the resources post-deployment.

## Support

For any queries or issues related to this project, feel free to contact:

    Email: alifiratcobanoglu@gmail.com
