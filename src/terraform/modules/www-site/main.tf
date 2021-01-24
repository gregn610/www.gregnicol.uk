locals {
  cloudfront_s3_origin_name = "public_bucket"
  resource_prefix           = format("%s-%s", var.env_name, var.resource_name)

  ssm_parameter_root        = "${local.resource_prefix}-www"
  subdomain                 = var.env_name == "prod" ? "www" : "www-${var.env_name}"
}
