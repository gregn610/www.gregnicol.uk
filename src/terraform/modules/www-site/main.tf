locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
  subdomain = var.env_name == "prod" ? "www" : "www-${var.env_name}"
}
