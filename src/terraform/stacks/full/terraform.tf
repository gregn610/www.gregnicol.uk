
locals {
  resource_name_www = "${var.resource_name}-www"
}

locals {
  codecommit_arn    = "arn:aws:codecommit:${data.aws_region.current.id}:${data.aws_caller_identity.current.id}:${local.resource_name_www}"
  build_environment = {
    privileged_mode = "false"
    type            = "LINUX_CONTAINER"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0-20.09.14"
    compute_type    = "BUILD_GENERAL1_SMALL"
  }
  ssm_path_latest_build ="/${var.env_name}-${var.resource_name}-www/codebuild/${var.env_name}-${local.resource_name_www}/latest"  # format defined in codebuild module
}


module "www-site" {
  source = "../../modules//www-site"

  domain_name   = var.domain_name
  env_name      = var.env_name
  resource_name = var.resource_name
}
locals {
  buildspec_www_site = templatefile("${path.module}/templates/www-cicd-buildspec.yml", {
      TPL_SSM_PATH_CODEBUILD_LATEST = local.ssm_path_latest_build
      TPL_S3_DEPLOYMENT_BUCKET      = module.www-site.www_bucket_name
      TPL_CLOUDFRONT_ID             = module.www-site.cloudfront_distribution_id
      TPL_CLOUDFRONT_ORIGIN         = module.www-site.cloudfront_s3_origin
  })
}

module "www-cicd" {
  source = "../../modules//www-cicd"

  env_name      = var.env_name
  resource_name = local.resource_name_www

  build_codebuild_policy = templatefile("${path.module}/templates/www-cicd-codebuild-policy.json", {
    TPL_CODECOMMIT_ARN = local.codecommit_arn
  })
  build_environment = local.build_environment
  build_buildspec   = local.buildspec_www_site
  deploy_bucket     = module.www-site.www_bucket_name
}
