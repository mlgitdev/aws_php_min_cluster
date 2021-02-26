variable "vpc_id" {
  type = string
}
variable "project" {
  type = string
}
variable "app_id" {
  type = string
}
locals {
  app_env = lower(terraform.workspace)
}
variable "office_ip" {
  description = "Office IP to connect to services"
  default     = null
}
variable "office_vgw" {
  default = ""
}

variable "office_subnets" {
  default = []
}
