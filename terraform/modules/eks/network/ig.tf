resource "aws_internet_gateway" "eks_ig" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name    = "${var.app_id}-${local.app_env}-ig"
    project = var.project
  }
}

