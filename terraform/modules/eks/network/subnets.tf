data "aws_availability_zones" "available" {
}

# ============================================== NONSECURE =======================================================
resource "aws_subnet" "eks_private_subnet" {
  count             = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = length(split(".", "${local.vpc_network}")) == 2 ? "${local.vpc_network}.${count.index * 2}.0/24" : var.eks_private_subnets[count.index]
  vpc_id            = aws_vpc.eks_vpc.id

  tags = {
    "Name"                                        = "${var.app_id}-${local.app_env}-privatesubnet-${count.index + 1}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "project"                                     = var.project
    "Environment"                                 = local.app_env
  }
}

resource "aws_subnet" "eks_public_subnet" {
  count             = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = length(split(".", "${local.vpc_network}")) == 2 ? "${local.vpc_network}.1${count.index}.0/24" : var.eks_public_subnets[count.index]
  vpc_id            = aws_vpc.eks_vpc.id

  tags = {
    "Name"                                        = "${var.app_id}-${local.app_env}-publicsubnet-${count.index + 1}"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "project"                                     = var.project
    "Environment"                                 = local.app_env
  }
}

resource "aws_subnet" "db_subnet" {
  count             = var.subnet_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = length(split(".", "${local.vpc_network}")) == 2 ? "${local.vpc_network}.2${count.index}.0/24" : var.eks_db_subnets[count.index]
  vpc_id            = aws_vpc.eks_vpc.id

  tags = {
    "Name"        = "${var.app_id}-${local.app_env}-dbsubnet-${count.index + 1}"
    "project"     = var.project
    "Environment" = local.app_env
  }
}
