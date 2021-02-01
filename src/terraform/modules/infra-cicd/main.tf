# locals broken up to make dependencies more explicit
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
}
locals {
  artifact_bucket_name = format("%s-www-artifacts-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
  build_name           = local.resource_prefix
  build_namespace      =  "CICD_BUILD"
  deploy_namespace     = "CICD_DEPLOY"
  repository_name      = local.resource_prefix
  source_namespace     = "CICD_SOURCE"

}

locals {
  build_sourcecode = {
    type      = "CODECOMMIT"
    location = "https://git-codecommit.${data.aws_region.current.id}.amazonaws.com/v1/repos/${local.repository_name}"
    buildspec = var.build_buildspec
    git_clone_depth = 1
  }
  environment_variables = {
    CLOUDAUTH_BASE_URL         = var.cloudauth_base_url
    CLOUDAUTH_CLIENT_ID        = var.cloudauth_client_id
    CLOUDAUTH_CLIENT_SECRET    = var.cloudauth_client_secret
    CLOUDAUTH_REDIRECT_URI     = var.cloudauth_redirect_uri
    CLOUDAUTH_SESSION_DURATION = var.cloudauth_session_duration
  }
}
