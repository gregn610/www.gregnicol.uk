locals {
  resource_prefix                = format("%s-%s", var.env_name, var.resource_name)
  cloudfront_s3_origin_name      = "public_bucket"
  cloudfront_auth_lambda_name    = "${local.resource_prefix}-cloud-auth-at-edge"
  cloudfront_auth_lambda_key     = format("%s-%s-infra/package.zip", var.env_name, var.resource_name) # NB "infra", not "www"
  cloudfront_auth_lambda_handler = "index.handler"
  cloudfront_auth_lambda_runtime = "nodejs12.x"

  ssm_parameter_root = "${local.resource_prefix}-www"
  subdomain          = var.env_name == "prod" ? "www" : "www-${var.env_name}"
  auth_domain        = var.env_name == "prod" ? "auth.${var.domain_name}" : "auth-${var.env_name}.${var.domain_name}"
}
