# locals broken up to make dependencies more explicit
locals {
  resource_prefix = format("%s-%s", var.env_name, var.resource_name)
}
locals {
  artifact_bucket_name = format("%s-www-artifacts-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
  build_name           = local.resource_prefix
  build_namespace      =  "CICD_BUILD"
  deploy_namespace     = "CICD_DEPLOY"
  repository_name = local.resource_prefix
  source_namespace     = "CICD_SOURCE"

}

locals {
  build_sourcecode = {
    type      = "CODECOMMIT"
    location = "https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/prod-gregnicoluk-www" # ToDo: unhardcode
    buildspec = var.build_buildspec
    git_clone_depth = 1
  }
}

# ToDo: Rename module as it's not just "www" anymore, there is "infra" too. Need to move state too