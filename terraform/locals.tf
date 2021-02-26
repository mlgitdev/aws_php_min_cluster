locals {
  app_env = lower(terraform.workspace)
  env = {
    dev-beta = {
      spot                = true
      eks_instance_type   = "t3.medium"
      is_integration      = true
      vpc_cidr            = "10.1.0.0/16"
      vpc_network         = "10.1"
      master_rds_user     = "app_master"
      master_rds_password = "j$nHF%3_V6kaR1"
    }
    qa = {
      spot              = true
      eks_instance_type = "t3.medium"
      vpc_cidr          = "10.8.0.0/16"
      vpc_network       = "10.8"
      spot              = true
    }
    prod = {
      eks_instance_type    = "r4.large"
      vpc_cidr             = "10.8.0.0/16"
      vpc_network          = "10.8"
      multi_az             = true
      db_allocated_storage = 100
    }
    default = {
      region                  = var.aws_region
      cluster_version         = var.eks_version
      project                 = "${var.project_id_prefix}-${var.app_id_prefix}-${terraform.workspace}"
      app_id                  = var.app_id_prefix
      eks_instance_type       = "t3.medium"
      node_disk_space         = 20
      instance_types          = list("m5.medium", "t3a.medium", "m4.medium", "m5a.medium", "t3.medium")
      spot_types              = list("m5.medium", "t3a.medium", "m5d.medium", "m5a.medium", "t3.medium")
      spot_asgs               = "3"
      above_base_capacity     = "0"
      on_demand_base_capacity = "0"
      rds_enable              = true
      redis_enable            = false
      db_subnet_count         = 2
      db_instance_type        = "t3.medium"
      redis_instance_type     = "r4.large"
      db_engine               = "mariadb"
      db_version              = "10.3"
      # db_parameter_group      = var.db_parameter_group
      multi_az             = false
      db_allocated_storage = 20
      master_rds_user      = var.master_rds_user
      master_rds_password  = var.master_rds_password
      subnet_count         = var.subnet_count
      asg_desired          = 2
      asg_min              = 2
      asg_max              = 4
    }
  }
  environmentvars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace       = merge(local.env["default"], local.env[local.environmentvars])
  project         = local.workspace["project"]
  cluster_admin   = "arn:aws:iam::227735533269:user/EKS-${var.project_owner}"
  cluster_roles = {
    cluster-admins = {
      name         = "cluster-admins"
      api_groups   = ["*"]
      resources    = ["*"]
      verbs        = ["*"]
      iam_role_arn = var.iam_role_admin_assume_arn
    },
    cluster-users = {
      name         = "cluster-users"
      api_groups   = ["*"]
      resources    = ["*"]
      verbs        = ["get", "list", "watch"]
      iam_role_arn = var.iam_role_user_assume_arn
    }
  }
  map_users = {
    userarn  = local.cluster_admin
    username = "clusterAdmin:{{SessionName}}"
    groups   = ["system:masters"]
  }
}