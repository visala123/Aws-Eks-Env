variable "cluster_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {
  type = string
}
variable "key_name" {
  type = string
}
variable "desired_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "instance_type" {
  type = string
}
variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}
variable "eks_cluster_role" {}
variable "eks_node_role" {}
