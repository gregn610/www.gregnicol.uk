
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
}


module "www-site" {
  source = "../../modules//www-site"

  domain_name   = var.domain_name
  env_name      = var.env_name
  resource_name = var.resource_name
}
