variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where resources will be created"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
    GitOps      = "true"
  }
}
