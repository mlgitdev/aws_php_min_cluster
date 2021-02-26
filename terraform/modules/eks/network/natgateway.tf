resource "aws_eip" "eks_nat_gateway" {
  count = var.subnet_count
  vpc   = true
}
resource "aws_nat_gateway" "eks_nat_gateway" {
  count         = var.subnet_count
  allocation_id = aws_eip.eks_nat_gateway[count.index].id
  subnet_id     = aws_subnet.eks_public_subnet[count.index].id
  tags = {
    Name    = "${var.app_id}-${local.app_env}-nat-gateway-${count.index + 1}"
    project = var.project
  }
  depends_on = [aws_internet_gateway.eks_ig]
}
