variable "aws_region" {
  default = "eu-north-1"
}
variable "subnet_count" {
  default = 2
}
variable "domain_name" {
  default = "lekars.com"
}
variable "db_parameter_group" {
  default = null
}
variable "master_rds_user" {
  default = "should be defined during deployment"
}
variable "master_rds_password" {
  default = "should be defined during deployment"
}
variable "office_ip" {
  description = "Office IP to connect to services"
  default     = null
}
variable "eks_version" {
  type = string
}
variable "project_id_prefix" {
  description = "Enter the Project Owner Prefix"
  type        = string
}
variable "app_id_prefix" {
  description = "Enter the Project Name (as a prefix/suffix without the owner)"
  type        = string
}
variable "project_owner" {
  description = "The Project/Program Owner name"
  type        = string
}
variable "iam_eks_alb_ingress_policy_arn" {}
variable "iam_eks_autoscaling_policy_arn" {}
variable "iam_role_admin_assume_arn" {}
variable "iam_role_user_assume_arn" {}
# variable "map_users" {
#   description = "Additional IAM users to add to the aws-auth configmap."
#   type = list(object({
#     userarn  = string
#     username = string
#     groups   = list(string)
#   }))

#   default = [
#     {
#       userarn  = "arn for user 1"
#       username = "username"
#       groups   = ["system:masters"]
#     },
#     {
#       userarn  = "arn for another user"
#       username = "username"
#       groups   = ["system:masters"]
#     },
#   ]
# }