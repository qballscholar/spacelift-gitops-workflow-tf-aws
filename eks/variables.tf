# Define the name of the EKS cluster
variable "tags" {
type = map(string)
default = {
    Terraform  = "true"
    Kubernetes = "spacelift-eks-cluster"
    GitOps      = "true"
    Environment = "dev"
}

description = "Tags to apply to all resources"
}

variable "cluster_name" {
    type = string
    default = "spacelift-eks-cluster"

}

variable "eks_version" {
type = string
default = "1.31"
description = "EKS version"
}

# Add these variables to ./eks/variables.tf
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of IDs of private subnets"
  type        = list(string)
}
