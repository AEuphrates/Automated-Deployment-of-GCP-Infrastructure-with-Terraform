# Retrieving Compute Engine Instances Information
After successfully deploying your Google Cloud Platform (GCP) infrastructure with Terraform, you can retrieve essential details about the created Compute Engine instances. This information includes the names and internal IP addresses of the instances, which are crucial for further configuration and management tasks.

## Outputs
The Terraform configuration defines several outputs that you can use to access information about the deployed resources. Here's how to use them:

### **Instance Names and IP Addresses:**
- To get the name of the first Compute Engine instance, use the output instance_name_1.
- To get the internal IP address of the first Compute Engine instance, use the output instance_ip_1.
- Similarly, use instance_name_2 and instance_ip_2 for the second Compute Engine instance.

  ### How to View Outputs

  After applying your Terraform configuration with `terraform apply`, Terraform displays the values of these outputs at the end of the command's execution. You can also query these outputs at any time using the following command:

- **terraform output**
  
  This command lists all the output variables and their current values. To retrieve a specific output value, you can specify the output name, for example:
- terraform output instance_name_1
- terraform output instance_ip_1

Use these commands to obtain the names and internal IP addresses of the Compute Engine instances created by your Terraform configuration.
