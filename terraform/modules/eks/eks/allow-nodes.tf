data "external" "aws_iam_authenticator" {
  # To make this command run you will have to configure profile "export AWS_PROFILE=<Profile>"
  program = ["sh", "-c", "aws-iam-authenticator token -i ${local.cluster_name} | jq -r -c .status"]
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.external.aws_iam_authenticator.result.token
  # load_config_file       = false
}
resource "null_resource" "sleep" {
  depends_on = [aws_eks_cluster.eks]
  provisioner "local-exec" {
    command = "sleep 60s"
  }
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [
  aws_eks_cluster.eks, null_resource.sleep]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.eks-workers.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
    EOF
    mapUsers = yamlencode(var.map_users)
    #     mapUsers = <<EOF
    # - userarn: ${var.cluster_admin}
    #   username: clusterAdmin:{{SessionName}}
    #   groups:
    #     - system:masters
    #     EOF
  }
}
