resource "aws_route_table" "eks_private_subnet" {
  count  = var.subnet_count
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway[count.index].id
  }
  # route {
  #   cidr_block = "${var.office_ip}/32"
  #   gateway_id = aws_internet_gateway.eks_ig.id
  # }
  tags = {
    Name        = "${var.app_id}-${local.app_env}-rt-privatesubnets-${count.index + 1}"
    project     = var.project
    Environment = local.app_env
  }
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
}

resource "aws_route_table" "eks_public_subnet" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_ig.id
  }
  tags = {
    Name        = "${var.app_id}-${local.app_env}-rt-publicsubnets"
    project     = var.project
    Environment = local.app_env
  }
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
}

resource "aws_route_table" "db_subnet" {
  count  = var.subnet_count
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat_gateway[count.index].id
  }
  route {
    cidr_block = "${var.office_ip}/32"
    gateway_id = aws_internet_gateway.eks_ig.id
  }
  tags = {
    Name        = "${var.app_id}-${local.app_env}-rt-db-${count.index + 1}"
    project     = var.project
    Environment = local.app_env
  }
}

resource "aws_route_table_association" "eks_private_subnet" {
  count = var.subnet_count

  subnet_id      = aws_subnet.eks_private_subnet[count.index].id
  route_table_id = aws_route_table.eks_private_subnet[count.index].id
}

resource "aws_route_table_association" "eks_public_subnet" {
  count = var.subnet_count

  subnet_id      = aws_subnet.eks_public_subnet[count.index].id
  route_table_id = aws_route_table.eks_public_subnet.id
}

resource "aws_route_table_association" "db_subnet" {
  count = var.subnet_count

  subnet_id      = aws_subnet.db_subnet.*.id[count.index]
  route_table_id = aws_route_table.db_subnet.*.id[count.index]
}


#office vpn
resource "aws_route" "office_eks_privte_route" {
  count                  = length(var.office_subnets) == 0 ? 0 : var.subnet_count
  route_table_id         = aws_route_table.eks_private_subnet[count.index].id
  destination_cidr_block = var.office_subnets[0]
  gateway_id             = var.office_vgw
}

resource "aws_route" "office_eks_public_route" {
  count                  = length(var.office_subnets)
  route_table_id         = aws_route_table.eks_public_subnet.id
  destination_cidr_block = var.office_subnets[count.index]
  gateway_id             = var.office_vgw
}
