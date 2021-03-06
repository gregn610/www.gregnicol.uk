resource "aws_iam_group" "builders" {
  name = "${local.resource_prefix}-builders"
  path = "/${local.resource_prefix}/builders/"
}

module "codecommit" {
  source          = "git::https://github.com/gregn610/terraform-aws-codecommit?ref=v0.3.11"  # forked (unchanged) from  jameswoolfenden/terraform-aws-codecommit

  default_branch  = var.default_branch
  developer_group = aws_iam_group.builders.name
  repository_name = local.repository_name
}

resource "aws_iam_role" "codebuild" {
  # can't use the module generated version because the policy is tweaked with the S3 deploy_bucket access
  name  = "${local.resource_prefix}-codebuildrole"
  assume_role_policy = <<HERE
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
HERE

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "codecommit_readonly" {
  role  = aws_iam_role.codebuild.id
  policy_arn = data.aws_iam_policy.codecommit_readonly.arn
}

resource "aws_iam_role_policy" "codebuild_policy" {
  # can't use the module generated version because the policy is tweaked with the S3 deploy_bucket access
  name  = "${local.resource_prefix}-codebuildpolicy"
  role  = aws_iam_role.codebuild.id
  policy = var.build_codebuild_policy
}

module "codebuild" {
  source                 = "../../modules//mod-codebuild"
  depends_on = [
    aws_iam_role.codebuild
  ]

  artifact_type          = var.artifact_type
  bucketname             = var.artifact_bucket_name
  build_timeout          = var.build_timeout
  common_tags            = var.common_tags
  defaultbranch          = var.default_branch
  description            = "${local.resource_prefix} build"
  environment            = var.build_environment
  environment_variables  = local.environment_variables
  name                   = local.build_name
  role                   = aws_iam_role.codebuild.name
  projectroot            = local.resource_prefix  # used in the SSM parameters path
  sourcecode             = local.build_sourcecode
  git_submodules_config  = {
    fetch_submodules = true
  }
  versioning             = true  # artifact bucket versioning
}

module "codepipeline" {
  source                 = "../../modules//mod-codepipeline" # Forked for stages.action.namespaces

  artifact_store = {
    location = module.codebuild.artifact_bucket
    type = "S3"
  }

  common_tags = var.common_tags
  description = "${local.resource_prefix} pipeline"
  name 	      = local.repository_name
  stages      = [
    {
    name = "Source"
    action = {
        name     = "Source"
        category = "Source"
        owner    = "AWS"
        namespace = local.source_namespace
        provider = "CodeCommit"
        version  = "1"
        configuration = {
          BranchName           = var.default_branch
          OutputArtifactFormat = "CODE_ZIP"
          PollForSourceChanges = "false"
          RepositoryName       = local.repository_name
        }
        input_artifacts  = []
        output_artifacts = ["SourceArtifact"]
      }
    },
    {
      name = "Build"
      action = {
        name             = "Build"
        category         = "Build"
        owner            = "AWS"
        namespace       = local.build_namespace
        provider         = "CodeBuild"
        input_artifacts  = ["SourceArtifact"]
        output_artifacts = ["BuildArtifact"]
        version          = "1"
        configuration = {
          ProjectName = local.build_name
        }
      }
    }
  ]
}
