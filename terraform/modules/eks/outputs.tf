output "cluster_name" {
  value = aws_eks_cluster.example.name
}
output "subnet_ids" {
  value = var.subnet_ids
}

# output "cluster_endpoint" {
#   value = aws_eks_cluster.example.endpoint
# }
