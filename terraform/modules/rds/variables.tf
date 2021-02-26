variable "vpc_id" {}
variable "app_id" {}
variable "db_instance_type" {}
variable "master_rds_user" {}
variable "master_rds_password" {}
variable "parameter_group" {
  default = null
}
variable "sg-rds" {}
variable "db_subnets" {}
variable "project" {}
variable "enable" {
  type    = bool
  default = false
}
variable "engine" {
  type    = string
  default = "mysql"
}
variable "engine_version" {
  type    = string
  default = "5.7"
}
variable "storage_type" {
  type    = string
  default = "io1"
}
variable "allocated_storage" {
  type    = number
  default = 100
}
variable "max_allocated_storage" {
  type    = number
  default = null
}
variable "iops" {
  type    = number
  default = 1000
}
variable "storage_encrypted" {
  type    = bool
  default = true
}
variable "multi_az" {
  type    = bool
  default = false
}
variable "deletion_protection" {
  type    = bool
  default = true
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "maintenance_window" {
  type    = string
  default = "Sat:00:00-Sat:03:00"
}
#####################################
# Monitoring
variable "enable_monitoring" {
  type    = bool
  default = false
}
variable "insufficient_data_actions" {
  default = []
}
variable "ok_actions" {
  default = ""
}
variable "alarm_actions" {
  default = ""
}
variable "alarm_cpu_credit_balance_threshold" {
  default = ""
}
variable "alarm_free_memory_threshold" {
  default = ""
}
variable "alarm_free_disk_threshold" {
  default = ""
}
variable "alarm_disk_queue_threshold" {
  default = ""
}
variable "alarm_cpu_threshold" {
  default = ""
}