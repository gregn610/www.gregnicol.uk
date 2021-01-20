
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
}


module "www-site" {
  source = "../../modules//www-site"

  domain_name   = var.domain_name
  env_name      = var.env_name
  resource_name = var.resource_name
}

module "www-cicd" {
  source = "../../modules//www-cicd"

  build_environment = {
    privileged_mode = "false"
    type            = "LINUX_CONTAINER"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0-20.09.14"
    compute_type    = "BUILD_GENERAL1_SMALL"
  }
  deploy_bucket = module.www-site.www_bucket_name
  env_name      = var.env_name
  resource_name = var.resource_name
}
