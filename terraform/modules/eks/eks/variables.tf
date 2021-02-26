variable "private_subnets" {
  type = list(string)
}

variable "sg-master" {
  type = string
}

variable "sg-worker" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "project" {
  type = string
}
variable "app_id" {}
variable "asg_min" {}
variable "asg_max" {}
variable "asg_desired" {}
variable "map_users" {}
variable "spot" {}
variable "spot_types" {}
variable "spot_asgs" {}
variable "on_demand_base_capacity" {
  default = "0"
}
variable "above_base_capacity" {
  default = "0"
}
variable "instance_types" {}
variable "cluster_roles" {}
variable "node_disk_space" {
  default = 20
}
variable "iam_eks_alb_ingress_policy_arn" {
  default = ""
}
variable "iam_eks_autoscaling_policy_arn" {
  default = ""
}
variable "iam_ec2_container_registry_read_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
variable "iam_eks_cni_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
variable "iam_eks_workernode_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
variable "iam_eks_service_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}
variable "iam_eks_cluster_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
variable "iam_ec2_cluster_policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
