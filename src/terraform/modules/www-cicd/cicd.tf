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

module "codebuild" {
  source                 = "git::https://github.com/gregn610/terraform-aws-codebuild?ref=v0.2.110"  # forked ( unchanged) from "jameswoolfenden/codebuild/aws"

  artifact_type          = var.artifact_type
  build_timeout          = var.build_timeout
  common_tags            = var.common_tags
  defaultbranch          = var.default_branch
  description            = "${local.resource_prefix} build"
  environment            = var.build_environment
  name                   = local.build_name
  projectroot            = local.build_projectroot
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
    },
    {
      name = "Deploy"
      action = {
        name            = "PublishPublicS3Bucket"
        category        = "Deploy"
        owner           = "AWS"
        namespace       = local.deploy_namespace
        provider        = "S3"
        input_artifacts = ["BuildArtifact"]
        output_artifacts = []
#        role_arn        = module.iam_deploy_to_public_s3.role_arn
        version         = "1"
        configuration = {
          BucketName = var.deploy_bucket
          Extract = "true"
          ObjectKey = local.deploy_root_key
        }
      }
    }
  ]
}
