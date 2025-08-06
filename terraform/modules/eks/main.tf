resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }
}
data "aws_iam_role" "eks_cluster" {
  name = "my-eks-cluster-cluster-role" # <-- replace with the actual existing role name
}

data "aws_iam_role" "eks_node" {
  name = "my-eks-cluster-node-role" # <-- replace with actual name
}

# resource "aws_iam_role" "cluster" {
#   name = "${var.cluster_name}-cluster-role"

#   assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
# }

# data "aws_iam_policy_document" "cluster_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "cluster" {
#   role       = aws_iam_role.cluster.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]
  remote_access {
    ec2_ssh_key = var.key_name
    source_security_group_ids = [var.security_group_id]
  }

  #depends_on = [aws_iam_role_policy_attachment.node]
}

# resource "aws_iam_role" "node" {
#   name = "${var.cluster_name}-node-role"

#   assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
# }

# data "aws_iam_policy_document" "node_assume_role" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role_policy_attachment" "node" {
#   role       = aws_iam_role.node.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }