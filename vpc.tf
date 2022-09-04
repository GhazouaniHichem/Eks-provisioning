provider "aws" {
  region = "eu-west-3"
  profile = "default"
}

variable "vpc_cidr_block" {}
variable "private_subnet_cidr_blocks" {}
variable "public_subnet_cidr_blocks" {}
data "aws_availability_zones" "avail_zs" {}

module "eks-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.3"
  // Variables needed to configure vpc module
  name = "eks-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.avail_zs.names
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  
  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

}