# No backend configuration - Spacelift manages state
data "aws_availability_zones" "available" {
state = "available"
}

# Create VPC Module
module "eks-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  
  name = var.vpc_name
  cidr = var.cidr_block
  
  # Create 2 public subnets and 2 private subnets
  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = [cidrsubnet(var.cidr_block, 8, 110), cidrsubnet(var.cidr_block, 8, 120)]
  public_subnets  = [cidrsubnet(var.cidr_block, 8, 10), cidrsubnet(var.cidr_block, 8, 20)]
  
  # Create Internet Gateway, NAT Gateway, and Enable DNS Hostnames
  create_igw = true 

  enable_dns_hostnames = true 

 # Nat Gateway Configuration
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  create_private_nat_gateway_route = true 
  
  tags = var.tags
}
  
# Output of VPC ID, Public Subnets, and Private Subnets
output "vpc_id" {
  value = module.eks-vpc.vpc_id
  description = "The ID of the VPC"
}
