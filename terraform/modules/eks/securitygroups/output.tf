output "sg-master" {
  value = aws_security_group.eks-master.id
}
output "sg-worker" {
  value = aws_security_group.eks-workers.id
}
output "sg-rds" {
  value = aws_security_group.eks-rds.id
}
# output "sg-redis" {
#   value = aws_security_group.eks-redis.id
# }