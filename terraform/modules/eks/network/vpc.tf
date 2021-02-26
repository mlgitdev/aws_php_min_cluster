
resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name"                                        = "${var.app_id}-${local.app_env}-vpc"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "project"                                     = var.project
    "Environment"                                 = local.app_env
  }
}

