locals {
  app_env      = lower(terraform.workspace)
  cluster_name = "${var.app_id}-${lower(terraform.workspace)}-eks"
  kubeconfig   = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: ${local.cluster_name}
  name: ${local.cluster_name}
current-context: ${local.cluster_name}
kind: Config
preferences: {}
users:
- name: ${local.cluster_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${local.cluster_name}"
KUBECONFIG
}