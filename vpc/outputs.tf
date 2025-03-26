output "private_subnets" {
  value = module.eks-vpc.private_subnets
  description = "List of IDs of private subnets"
}

output "public_subnets" {
  value = module.eks-vpc.public_subnets
  description = "List of IDs of public subnets"
}

output "control_plane_subnet_ids" {
  value = concat(module.eks-vpc.public_subnets, module.eks-vpc.private_subnets)
  description = "Control plane subnet IDs"
}