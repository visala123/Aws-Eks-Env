# IAM roles must exist already if you're using data blocks
data "aws_iam_role" "eks_cluster" {
  name = var.eks_cluster_role
}

data "aws_iam_role" "eks_node" {
  name = var.eks_node_role
}

resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = data.aws_iam_role.eks_node.arn

  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [var.security_group_id]
  }

  depends_on = [aws_eks_cluster.example]
}

