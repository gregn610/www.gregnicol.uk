locals{
  cognito_identity_pool_provider = "COGNITO"
  dev_server = "localhost:8000"
  resource_name = "${local.resource_prefix}-www"
}

resource "aws_cognito_user_pool" "user_pool" {
  name                     = local.resource_name

  alias_attributes         = ["phone_number", "email", "preferred_username"]
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

//    recovery_mechanism {
//      name     = "verified_phone_number"
//      priority = 2
//    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length                   = 10
    require_uppercase                = false
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    temporary_password_validity_days = 3
  }

  tags = var.common_tags
}

resource "aws_cognito_user_pool_domain" "auth_domain" {
  domain          = local.auth_domain
  certificate_arn = module.acm.this_acm_certificate_arn
  user_pool_id    = aws_cognito_user_pool.user_pool.id
}

resource "aws_route53_record" "auth-cognito-A" {
  name    = aws_cognito_user_pool_domain.auth_domain.domain
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.auth_domain.cloudfront_distribution_arn
    # This zone_id is fixed for cloudfront
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_cognito_user_pool_client" "site_client" {
  name = "${local.resource_name}-site"
  supported_identity_providers = [local.cognito_identity_pool_provider]

  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  callback_urls = [
    "https://${local.subdomain}.${var.domain_name}/secure/_callback",
  ]
  # If / when there's a secure app, provide a better logout
  logout_urls = [
    "https://${local.subdomain}.${var.domain_name}/",
  ]
  allowed_oauth_flows = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [
#    "phone",
    "email",
    "openid",
#    "aws.cognito.signin.user.admin",
#    "profile",
  ]
  # issue: https://github.com/terraform-providers/terraform-provider-aws/issues/4476
  read_attributes  = ["email", "email_verified", "preferred_username", "profile"]
  write_attributes = ["email", "preferred_username", "profile"]

  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"  # copied from CFN example deployment
  ]
  prevent_user_existence_errors = "ENABLED"
}
//
//resource "aws_cognito_identity_pool" "_" {
//  identity_pool_name      = local.resource_name
//  developer_provider_name = local.cognito_identity_pool_provider
//
//  allow_unauthenticated_identities = false
//
//  cognito_identity_providers {
//    client_id               = aws_cognito_user_pool_client.pool_client.id
//    server_side_token_check = true
//
//    provider_name = "cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
//  }
//}
