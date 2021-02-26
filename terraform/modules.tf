module "network" {
  source       = "./modules//eks//network"
  region       = local.workspace["region"]
  subnet_count = local.workspace["subnet_count"]
  project      = local.project
  app_id       = local.workspace["app_id"]
  vpc_cidr     = local.workspace["vpc_cidr"]
  vpc_network  = local.workspace["vpc_network"]
  office_ip    = var.office_ip
}

module "securitygroup" {
  source    = "./modules//eks//securitygroups"
  vpc_id    = module.network.vpc_id
  project   = local.project
  app_id    = local.workspace["app_id"]
  office_ip = var.office_ip
}

module "eks" {
  source          = "./modules//eks//eks"
  instance_type   = local.workspace["eks_instance_type"]
  project         = local.project
  private_subnets = module.network.private_subnets
  sg-master       = module.securitygroup.sg-master
  sg-worker       = module.securitygroup.sg-worker
  node_disk_space = local.workspace["node_disk_space"]
  cluster_version = local.workspace["cluster_version"]
  asg_desired     = local.workspace["asg_desired"]
  asg_min         = local.workspace["asg_min"]
  asg_max         = local.workspace["asg_max"]
  app_id          = local.workspace["app_id"]
  map_users       = local.map_users
  cluster_roles   = local.cluster_roles
  # cluster_admin   = local.cluster_admin
  instance_types                 = local.workspace["instance_types"]
  on_demand_base_capacity        = local.workspace["on_demand_base_capacity"]
  above_base_capacity            = local.workspace["above_base_capacity"]
  spot                           = local.workspace["spot"]
  spot_types                     = local.workspace["spot"] == true ? local.workspace["spot_types"] : null
  spot_asgs                      = local.workspace["spot"] == true ? local.workspace["spot_asgs"] : null
  iam_eks_alb_ingress_policy_arn = var.iam_eks_alb_ingress_policy_arn
  iam_eks_autoscaling_policy_arn = var.iam_eks_autoscaling_policy_arn
}

module "rds" {
  source              = "./modules//rds"
  enable              = local.workspace["rds_enable"]
  vpc_id              = module.network.vpc_id
  project             = local.project
  app_id              = local.workspace["app_id"]
  engine              = local.workspace["db_engine"]
  engine_version      = local.workspace["db_version"]
  allocated_storage   = local.workspace["db_allocated_storage"]
  multi_az            = local.workspace["multi_az"]
  db_instance_type    = local.workspace["db_instance_type"]
  master_rds_user     = local.workspace["master_rds_user"]
  master_rds_password = local.workspace["master_rds_password"]
  sg-rds              = module.securitygroup.sg-rds
  db_subnets          = module.network.db_subnets
}