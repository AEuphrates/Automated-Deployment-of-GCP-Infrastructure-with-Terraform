variable "project_id" {
  description = "your project id"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "projects/potent-poet-417708/global/networks/vpc-network-vtnu3e"
}
