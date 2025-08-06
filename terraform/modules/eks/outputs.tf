output "cluster_name" {
  value = aws_eks_cluster.example.name
}
output "subnet_ids" {
  value = data.aws_subnets.selected.ids
}

# output "cluster_endpoint" {
#   value = aws_eks_cluster.example.endpoint
# }
