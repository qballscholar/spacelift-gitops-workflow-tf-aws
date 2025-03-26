# Define the CIDR block for the VPC
variable "cidr_block" {
type = string
default = "10.10.0.0/16"
}

# Define the name of the VPC
variable "vpc_name" {
type = string
default = "spacelift-eks-vpc" 
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
    GitOps      = "true"
  }
}