provider "aws" {
  region = "us-east-1"
}

# Get the default VPC (or tag-specific one)
data "aws_vpc" "default" {
  default = true
}

# Fetch all subnets with a specific tag
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # Optional: filter by tag if needed
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

# Fetch security group by tag or name
data "aws_security_group" "eks_sg" {
  filter {
    name   = "tag:Name"
    values = [var.security_group_id]
  }

  vpc_id = data.aws_vpc.default.id
}

# Fetch existing key pair
data "aws_key_pair" "eks_key" {
  key_name = var.key_name # Make sure this key exists in AWS
}
data "aws_iam_role" "eks_cluster" {
  name = var.eks_cluster_role #"my-eks-cluster-cluster-role" # <-- replace with the actual existing role name
}

data "aws_iam_role" "eks_node" {
  name = var.eks_node_role #"my-eks-cluster-node-role" # <-- replace with actual name
}

module "eks" {
  source            = "../../modules/eks"

  cluster_name      = var.cluster_name
  subnet_ids          = data.aws_subnets.selected.ids
  security_group_id = data.aws_security_group.eks_sg.id
  key_name          = data.aws_key_pair.eks_key.key_name
  cluster_role_arn    = data.aws_iam_role.eks_cluster.arn
  node_role_arn       = data.aws_iam_role.eks_node.arn

  desired_size = var.desired_size
  max_size     = var.max_size
  min_size     = var.min_size
  instance_type = var.instance_type
}

