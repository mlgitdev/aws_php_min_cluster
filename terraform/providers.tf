provider "aws" {
  region = var.aws_region
  # shared_credentials_file = "~/.aws/credentials"
  # profile                 = "myapp"
}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    bucket               = "terraform-aqua-store" # output of the command 'terraform output s3_bucket'
    key                  = "terraform.tfstate"    # path to the state file - change according to the project - customer/project.tfstate
    region               = "eu-central-1"
    dynamodb_table       = "terraform-state-lock-dynamo" # output of the command 'terraform output dynamodb_table_name'
    workspace_key_prefix = "myapp/env:"
    encrypt              = true
    # shared_credentials_file = "~/.aws/credentials"
    # profile                 = "myapp"
  }
}