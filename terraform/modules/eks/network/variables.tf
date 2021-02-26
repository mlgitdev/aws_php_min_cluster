variable "subnet_count" {}

variable "project" {
  type = string
}

variable "region" {
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "app_id" {
  type = string
}

variable "vpc_network" {
  type = string
}

variable "eks_private_subnets" {
  default = []
}

variable "eks_public_subnets" {
  default = []
}

variable "eks_db_subnets" {
  default = []
}

locals {
  vpc_network  = var.vpc_network
  app_env      = lower(terraform.workspace)
  cluster_name = "${var.app_id}-${lower(terraform.workspace)}-eks"
}

variable "transit_gateway_count" {
  default = 0
}

variable "office_ip" {
  description = "Office IP to connect to services"
  default     = null
}
variable "office_vgw" {
  default = ""
}

variable "office_subnets" {
  default = []
}
