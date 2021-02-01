resource "aws_codebuild_project" "project" {
  # test is wrong
  # checkov:skip=CKV_AWS_78: "Ensure that CodeBuild Project encryption is not disabled"
  name          = replace(var.name, ".", "-")
  description   = var.description
  service_role  = var.role == "" ? element(concat(aws_iam_role.codebuild.*.arn, list("")), 0) : element(concat(data.aws_iam_role.existing.*.arn, list("")), 0)
  build_timeout = var.build_timeout

  artifacts {
    encryption_disabled = var.encryption_disabled
    location            = local.bucketname
    name                = var.name
    namespace_type      = var.artifact["namespace_type"]
    packaging           = var.artifact["packaging"]
    type                = var.artifact_type
  }

  environment {
    compute_type    = var.environment["compute_type"]
    image           = var.environment["image"]
    type            = var.environment["type"]
    privileged_mode = var.environment["privileged_mode"]

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value

      }
    }
  }

  source {
    type            = var.sourcecode["type"]
    location        = var.sourcecode["location"]
    buildspec       = var.sourcecode["buildspec"]
    git_clone_depth = var.sourcecode["git_clone_depth"]
    git_submodules_config {
      fetch_submodules = var.git_submodules_config["fetch_submodules"]
    }
  }
  source_version    = var.source_version

  tags = var.common_tags
}
