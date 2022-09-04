provider "kubernetes" {
  load_config_file = "false"
  host = data.aws_eks_cluster.myapp-cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"
  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.17"
  subnets = module.eks-vpc.private_subnets
  vpc_id = module.eks-vpc.vpc_id
  tags = {
    environment = "Development"
    application = "myapp"
  }
  worker_groups = [
    {
        instance_type = "t2.small"
        name = "worker-group-1"
        asg_desired_capacity = 3
    },
    {
        instance_type = "t2.medium"
        name = "worker-group-2"
        asg_desired_capacity = 2
    }
  ]
}