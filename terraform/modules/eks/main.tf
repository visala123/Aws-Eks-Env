# data "aws_subnets" "selected" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }
# }
resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids         =var.subnet_ids[0]    #data.aws_subnets.selected.ids
    security_group_ids = [var.security_group_id]
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "${var.cluster_name}-node-group"

  node_role_arn = var.node_role_arn
  subnet_ids    =var.subnet_ids[0] #data.aws_subnets.selected.ids

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
}