resource "aws_db_instance" "rds_instance" {
  count                  = var.enable ? 1 : 0
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  iops                   = var.storage_type == "io1" ? var.iops : null
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.db_instance_type
  identifier             = "${var.app_id}-${local.app_env}-rds"
  username               = var.master_rds_user
  password               = var.master_rds_password
  parameter_group_name   = var.parameter_group
  storage_encrypted      = var.storage_encrypted
  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.rds_subgroup.name
  deletion_protection    = var.deletion_protection
  vpc_security_group_ids = [var.sg-rds]
  publicly_accessible    = var.publicly_accessible
  maintenance_window     = var.maintenance_window
  skip_final_snapshot    = true
  tags = {
    Name        = "${var.app_id}-${local.app_env}-rds"
    Environment = local.app_env
    project     = var.project
  }
}

resource "aws_db_subnet_group" "rds_subgroup" {
  name       = "${lower(var.app_id)}-${lower(local.app_env)}-subnetgroup"
  subnet_ids = ["${var.db_subnets[0]}", "${var.db_subnets[1]}"]
}
