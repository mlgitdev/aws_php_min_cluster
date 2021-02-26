resource "aws_security_group_rule" "eks-workers-ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-workers.id
  source_security_group_id = aws_security_group.eks-workers.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-workers-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-workers.id
  source_security_group_id = aws_security_group.eks-master.id
  to_port                  = 65535
  type                     = "ingress"
}

# allow worker nodes to access EKS master
resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-workers.id
  source_security_group_id = aws_security_group.eks-master.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-workers-ingress-master" {
  description              = "Allow cluster control to receive communication from the worker Kubelets"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-master.id
  source_security_group_id = aws_security_group.eks-workers.id
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "eks-rds-workers" {
  description              = "Allow workers connect to RDS"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-rds.id
  source_security_group_id = aws_security_group.eks-workers.id
  to_port                  = 3306
  type                     = "ingress"
}
resource "aws_security_group_rule" "eks-rds-office" {
  description       = "Allow Office connect to RDS"
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-rds.id
  cidr_blocks       = ["${var.office_ip}/32"]
  to_port           = 3306
  type              = "ingress"
}
# resource "aws_security_group_rule" "eks-redis-workers" {
#   description              = "Allow workers connect to Redis"
#   from_port                = 6379
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.eks-redis.id
#   source_security_group_id = aws_security_group.eks-workers.id
#   to_port                  = 6379
#   type                     = "ingress"
# }
# resource "aws_security_group_rule" "eks-redis-office" {
#   description       = "Allow Office connect to Redis"
#   from_port         = 6379
#   protocol          = "tcp"
#   security_group_id = aws_security_group.eks-redis.id
#   cidr_blocks       = ["${var.office_ip}/32"]
#   to_port           = 6379
#   type              = "ingress"
# }
resource "aws_security_group_rule" "office-vpn-to-eks" {
  count             = length(var.office_subnets) == 0 ? 0 : 1
  description       = "Allow office vpn to connect to each other"
  from_port         = 0
  protocol          = "all"
  security_group_id = aws_security_group.eks-workers.id
  cidr_blocks       = var.office_subnets
  to_port           = 0
  type              = "ingress"
}
# allow ALB to probe worker nodes
resource "aws_security_group_rule" "eks-cluster-ingress-node-alb" {
  description              = "Allow ALB to communicate with pods"
  from_port                = 30000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-workers.id
  source_security_group_id = aws_security_group.pub_alb.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-cluster-ingress-node-alb-monitoring" {
  description              = "Allow Monitoring ALB to communicate with pods"
  from_port                = 30000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-workers.id
  source_security_group_id = aws_security_group.internal_alb.id
  to_port                  = 65535
  type                     = "ingress"
}
