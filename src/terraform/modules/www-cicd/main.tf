# locals broken up to make dependencies more explicit
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
  repository_name = "${local.resource_prefix}-www"
}
locals {
  artifact_bucket_name = format("%s-www-artifacts-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
  build_name           = local.repository_name
  build_namespace      =  "CICD_BUILD"
  build_projectroot    = local.repository_name
  deploy_namespace     = "CICD_DEPLOY"
  source_namespace     = "CICD_SOURCE"
}
locals {
  ssm_path_codebuild_latest = "/${local.build_projectroot}/codebuild/${local.build_name}/latest"  # format defined in codebuild module
}
locals {
  # Todo: need to pass in these too, currently hacked into terragrunt cache
  # source_version = "refs/heads/main"
  # git_submodules_config {
  #   fetch_submodules = false
  # }

  build_sourcecode = {
    type      = "CODECOMMIT"
    location = "https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/prod-gregnicoluk-www" # ToDo: unhardcode
    buildspec = templatefile("${path.module}/templates/buildspec.yml", {
      TPL_SSM_PATH_CODEBUILD_LATEST = local.ssm_path_codebuild_latest
      TPL_S3_DEPLOYMENT_BUCKET      = var.deploy_bucket
      TPL_CLOUDFRONT_ID             = var.cloudfront_distribution_id
      TPL_CLOUDFRONT_ORIGIN         = var.cloudfront_origin
    })
  }
}
