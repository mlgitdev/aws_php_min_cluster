resource "aws_iam_role" "eks_cluster" {
  name               = "${var.app_id}-${local.app_env}-cluster-iam"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = var.iam_eks_cluster_policy_arn
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = var.iam_eks_service_policy_arn
  role       = aws_iam_role.eks_cluster.name
}

# Setup IAM role & instance profile for worker nodes
resource "aws_iam_role" "eks-workers" {
  name               = "${var.app_id}-${local.app_env}-workers-iam"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-workers-AmazonEKSWorkerNodePolicy" {
  policy_arn = var.iam_eks_workernode_policy_arn
  role       = aws_iam_role.eks-workers.name
}

resource "aws_iam_role_policy_attachment" "eks-workers-AmazonEKS_CNI_Policy" {
  policy_arn = var.iam_eks_cni_policy_arn
  role       = aws_iam_role.eks-workers.name
}

resource "aws_iam_role_policy_attachment" "eks-workers-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = var.iam_ec2_container_registry_read_policy_arn
  role       = aws_iam_role.eks-workers.name
}

resource "aws_iam_role_policy_attachment" "eks-workers-eks-alb-ingress-permissions" {
  policy_arn = var.iam_eks_alb_ingress_policy_arn
  role       = aws_iam_role.eks-workers.name
}

resource "aws_iam_role_policy_attachment" "eks-workers-eks-autoscaling-permissions" {
  policy_arn = var.iam_eks_autoscaling_policy_arn
  role       = aws_iam_role.eks-workers.name
}

resource "aws_iam_instance_profile" "workers" {
  name = "${var.app_id}-${local.app_env}-iam-instanceprofile"
  role = aws_iam_role.eks-workers.name
}
