
locals {
  resource_name_www = "${var.resource_name}-www"
  resource_name_infra = "${var.resource_name}-infra"
}

locals {
  codecommit_arn_www    = "arn:aws:codecommit:${data.aws_region.current.id}:${data.aws_caller_identity.current.id}:${local.resource_name_www}"
  build_environment_www = {
    privileged_mode = "false"
    type            = "LINUX_CONTAINER"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0-20.09.14"
    compute_type    = "BUILD_GENERAL1_SMALL"
  }


  build_environment_infra = {
    privileged_mode = "false"
    type            = "LINUX_CONTAINER"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0-20.09.14"
    compute_type    = "BUILD_GENERAL1_SMALL"
  }
}

locals {
  buildspec_www_site = templatefile("${path.module}/templates/www-cicd-buildspec.yml", {
      TPL_SSM_PATH_CODEBUILD_LATEST = "/${var.env_name}-${local.resource_name_www}/codebuild/${var.env_name}-${local.resource_name_www}/latest"  # format defined in codebuild module
      TPL_S3_DEPLOYMENT_BUCKET      = module.www-site.www_bucket_name
      TPL_CLOUDFRONT_ID             = module.www-site.cloudfront_distribution_id
      TPL_CLOUDFRONT_ORIGIN         = module.www-site.cloudfront_s3_origin
  })
  buildspec_infra = templatefile("${path.module}/templates/infra-cicd-buildspec.yml", {
    TPL_SSM_PATH = "/${var.env_name}-${local.resource_name_infra}/codebuild"
  })
}

module "www-site" {
  source = "../../modules//www-site"

  domain_name   = var.domain_name
  env_name      = var.env_name
  resource_name = var.resource_name
}

# ToDo: hardcoded buckets in codebuild iam policy
module "www-cicd" {
  source = "../../modules//www-cicd"

  env_name      = var.env_name
  resource_name = local.resource_name_www

  build_codebuild_policy = templatefile("${path.module}/templates/www-cicd-codebuild-policy.json", {
    TPL_CODECOMMIT_ARN = local.codecommit_arn_www
  })
  build_environment = local.build_environment_www
  build_buildspec   = local.buildspec_www_site
  deploy_bucket     = module.www-site.www_bucket_name
}

# Based on https://github.com/JamesWoolfenden/terraform-aws-codebuild but forked for environment_variables etc.
module "infra-cicd" {
  source = "../../modules//infra-cicd"

  env_name      = var.env_name
  resource_name = local.resource_name_infra

  artifact_bucket_name = module.www-site.use1_deployment_bucket
  build_codebuild_policy = templatefile("${path.module}/templates/infra-cicd-codebuild-policy.json", {
    USE1_DEPLOYMENT_BUCKET = module.www-site.use1_deployment_bucket
  })
  build_environment          = local.build_environment_infra
  build_buildspec            = local.buildspec_infra
  cloudauth_base_url         = "https://cognito-idp.${data.aws_region.current.id}.amazonaws.com/${module.www-site.cognito_user_pool_id}"
  cloudauth_client_id        = module.www-site.cognito_user_pool_client_id
  cloudauth_response_type    = "code"
  cloudauth_scope            = "openid email"
  cloudauth_grant_type       = "authorization_code"
  cloudauth_redirect_uri     = "https://www.${var.domain_name}/secure/_callback"
  cloudauth_session_duration = 12 # Hours
}
