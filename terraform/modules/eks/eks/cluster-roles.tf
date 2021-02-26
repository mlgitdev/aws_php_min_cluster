#------------- Cluster Roles --------------------

# Create Cluster Roles
resource "kubernetes_cluster_role" "cluster-roles" {
  for_each = { for cluster_role in var.cluster_roles : cluster_role.name => cluster_role }
  metadata {
    name = each.value.name
  }

  rule {
    api_groups = each.value.api_groups
    resources  = each.value.resources
    verbs      = each.value.verbs
  }
  depends_on = [kubernetes_config_map.aws_auth]
}

#------------- Cluster Map Roles --------------------

resource "kubernetes_cluster_role_binding" "aws-group" {
  for_each = { for cluster_role in var.cluster_roles : cluster_role.name => cluster_role }
  metadata {
    name = "${each.value.name}-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value.name
  }
  subject {
    kind      = "Group"
    name      = each.value.name
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [kubernetes_config_map.aws_auth]
}