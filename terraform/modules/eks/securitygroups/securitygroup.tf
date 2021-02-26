resource "aws_security_group" "eks-master" {
  name        = "SG-${var.app_id}-${local.app_env}-eks-masters"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "SG-${var.app_id}-${local.app_env}-eks-masters"
    project     = var.project
    Environment = local.app_env
  }
}

resource "aws_security_group" "eks-workers" {
  name        = "SG-${var.app_id}-${local.app_env}-eks-workers"
  description = "Security group for all worker nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "SG-${var.app_id}-${local.app_env}-eks-workers"
    project     = var.project
    Environment = local.app_env
  }
}
resource "aws_security_group" "eks-rds" {
  name        = "SG-${var.app_id}-${local.app_env}-rds"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "SG-${var.app_id}-${local.app_env}-rds"
    project     = var.project
    Environment = local.app_env
  }
}
# resource "aws_security_group" "eks-redis" {
#   name        = "SG-${var.app_id}-${local.app_env}-redis"
#   description = "Security group for Redis"
#   vpc_id      = var.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "SG-${var.app_id}-${local.app_env}-redis"
#     project     = var.project
#     Environment = local.app_env
#   }
# }

resource "aws_security_group" "pub_alb" {
  name        = "SG-${var.app_id}-${local.app_env}-Pub-ALB"
  description = "Security group for ALB Public - cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "SG-${var.app_id}-${local.app_env}-Pub-ALB"
    project     = var.project
    Environment = local.app_env
  }
}

resource "aws_security_group" "internal_alb" {
  name        = "SG-${var.app_id}-${local.app_env}-Monitoring-ALB"
  description = "Security group for ALB Internal - monitoring"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "SG-${var.app_id}-${local.app_env}-Monitoring-ALB"
    project     = var.project
    Environment = local.app_env
  }
}
