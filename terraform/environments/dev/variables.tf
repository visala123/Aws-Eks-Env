variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
variable "key_name" {}
variable "desired_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "instance_type" {}
variable "cluster_role_arn" {}

variable "node_role_arn" {}
variable "eks_cluster_role" {}
variable "eks_node_role" {}
