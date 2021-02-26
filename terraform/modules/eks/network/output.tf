output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "vpc_id_secure" {
  value = aws_vpc.eks_vpc.id
}

output "private_subnets" {
  value = aws_subnet.eks_private_subnet.*.id
}

output "db_subnets" {
  value = aws_subnet.db_subnet.*.id
}
output "public_route_table_id" {
  value = aws_route_table.eks_public_subnet.id
}
output "private_route_table_id" {
  value = aws_route_table.eks_private_subnet.*.id
}
output "nat_gateway" {
  value = aws_nat_gateway.eks_nat_gateway[1].id
}
output "nat_gateway_az" {
  value = aws_subnet.eks_private_subnet[1].availability_zone
}

output "internet_gateway" {
  value = aws_internet_gateway.eks_ig.id
}
