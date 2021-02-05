# locals broken up to make dependencies more explicit
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
}
locals {
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
    CLOUDAUTH_RESPONSE_TYPE    = var.cloudauth_response_type
    CLOUDAUTH_SCOPE            = var.cloudauth_scope
    CLOUDAUTH_GRANT_TYPE       = var.cloudauth_grant_type
    CLOUDAUTH_REDIRECT_URI     = var.cloudauth_redirect_uri
    CLOUDAUTH_SESSION_DURATION = var.cloudauth_session_duration
  }
}
