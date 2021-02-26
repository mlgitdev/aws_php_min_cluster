output "eks_kubeconfig" {
  value = local.kubeconfig
  depends_on = [
    aws_eks_cluster.eks
  ]
}
output "eks-worker-role" {
  value = aws_iam_role.eks-workers.name
}
output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
output "eks_certificate" {
  value = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
}
output "eks_token" {
  value = data.external.aws_iam_authenticator.result.token
}