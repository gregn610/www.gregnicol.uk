# locals broken up to make dependencies more explicit
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
  repository_name = "${local.resource_prefix}-www"
}
locals {
  artifact_bucket_name = format("%s-www-artifacts-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
  build_name           = local.repository_name
  build_namespace  = "CICD_BUILD"
  build_projectroot    = local.repository_name
  deploy_namespace = "CICD_DEPLOY"
  source_namespace = "CICD_SOURCE"
}
locals {
  ssm_cloudfront_param = "/${local.build_projectroot}/codebuild/${local.build_name}/latest"  # format defined in codebuild module
}
locals {
  build_sourcecode = {
    type      = "CODECOMMIT"
    location  = local.repository_name
    buildspec = templatefile("${path.module}/templates/buildspec.yml", {
      SSM_CLOUDFRONT_PARAM = local.ssm_cloudfront_param
    })
  }
  # If no deploy_root_key provided, use the source commitId so
  # the cloudfront origin path can have instant/versioned updates
  deploy_root_key = var.deploy_root_key == "" ? "#{CICD_SOURCE.CommitId}" : var.deploy_root_key
}
