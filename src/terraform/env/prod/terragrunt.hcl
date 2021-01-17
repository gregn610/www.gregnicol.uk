terraform {
  source = "../..//stacks/full"
}

locals {
  env_name    = "prod"
  domain_name = "gregnicol.uk"
  aws_region  = "eu-west-2"
}

inputs = {
  env_name    = local.env_name
  domain_name = local.domain_name
  aws_region  = local.aws_region
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = format("terraform-remote-state-%s", get_aws_account_id())
    dynamodb_table = format("terraform-remote-state-%s", get_aws_account_id())
    key            = format("%s/vcv/terraform.tfstate", local.env_name)
    encrypt        = true
    region         = "eu-west-2"
  }
}

include {
  path = find_in_parent_folders()
}