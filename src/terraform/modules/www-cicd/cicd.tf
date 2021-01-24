resource "aws_iam_group" "www_editors" {
  name = "editors"
  path = "/${local.resource_prefix}/www/editors/"
}

module "codecommit" {
  source          = "git::https://github.com/gregn610/terraform-aws-codecommit?ref=v0.3.11"  # forked (unchanged) from  jameswoolfenden/terraform-aws-codecommit

  default_branch  = var.default_branch
  developer_group = aws_iam_group.www_editors.name
  repository_name = local.repository_name
}

resource "aws_iam_role" "codebuild" {
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

resource "aws_iam_role_policy" "codebuild_policy" {
  name  = "${local.resource_prefix}-codebuildpolicy"
  role  = aws_iam_role.codebuild.id

  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy" "codecommit_policy" {
  name  = "${local.resource_prefix}-codecommitpolicy"
  role  = aws_iam_role.codebuild.id

  policy =  data.aws_iam_policy_document.codecommit_policy.json
}

module "codebuild" {
  source                 = "git::https://github.com/gregn610/terraform-aws-codebuild?ref=v0.2.110"  # forked ( unchanged) from "jameswoolfenden/codebuild/aws"

  artifact_type          = var.artifact_type
  build_timeout          = var.build_timeout
  common_tags            = var.common_tags
  defaultbranch          = var.default_branch
  description            = "${local.resource_prefix} build"
  environment            = var.build_environment
  name                   = local.build_name
  role                   = aws_iam_role.codebuild.name
  projectroot            = local.build_projectroot  # used in the SSM parameters path
  sourcecode             = local.build_sourcecode
  versioning             = true  # artifact bucket versioning
}


module "codepipeline" {
  source                 = "git::https://github.com/gregn610/terraform-aws-codepipeline?ref=v0.3.38"  # forked from "jameswoolfenden/pipeline/aws"
                                                                                                      # namespace PR pending
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
