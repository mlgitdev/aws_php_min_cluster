resource "aws_eks_cluster" "eks" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.cluster_version
  vpc_config {
    security_group_ids = ["${var.sg-master}"]
    subnet_ids         = var.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy,
  ]

  tags = {
    Environment = local.app_env
    project     = var.project
  }
}