data "aws_canonical_user_id" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  bucketname = "${local.resource_prefix}-www-${data.aws_caller_identity.current.id}-artifacts"  # This must match up with the naming used inside the module
}

data "aws_iam_policy_document" "codebuild_policy" {
  # Copy pasted out of the module and supplemented with deploy bucket write permissions * cloudfront:GetDistribution
  statement {
    actions = [
      "cloudfront:GetDistribution"
    ]
    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.id}:distribution/*"
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:List*",
      "s3:PutObject",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${local.bucketname}",
      "arn:aws:s3:::${local.bucketname}/*",
      "arn:aws:s3:::codepipeline-${data.aws_region.current.name}-163714928765/*",
      "arn:aws:s3:::codepipeline-${data.aws_region.current.name}-163714928765",
      "arn:aws:s3:::${var.deploy_bucket}",
      "arn:aws:s3:::${var.deploy_bucket}/*",
    ]
  }

  statement {
    actions = [
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:UpdateProject"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:PutParameter",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "iam:ListRoles",
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "codecommit_policy" {
  statement {
    actions = [
      "codecommit:GetTree",
      "codecommit:ListPullRequests",
      "codecommit:GetBlob",
      "codecommit:GetReferences",
      "codecommit:GetCommentsForComparedCommit",
      "codecommit:GetCommit",
      "codecommit:GetComment",
      "codecommit:GetCommitHistory",
      "codecommit:GetCommitsFromMergeBase",
      "codecommit:DescribePullRequestEvents",
      "codecommit:GetPullRequest",
      "codecommit:ListBranches",
      "codecommit:GetRepositoryTriggers",
      "codecommit:GitPull",
      "codecommit:BatchGetRepositories",
      "codecommit:GetCommentsForPullRequest",
      "codecommit:GetObjectIdentifier",
      "codecommit:CancelUploadArchive",
      "codecommit:GetFolder",
      "codecommit:BatchGetPullRequests",
      "codecommit:GetFile",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:GetDifferences",
      "codecommit:GetRepository",
      "codecommit:GetBranch",
      "codecommit:GetMergeConflicts"
    ]
    resources = [
      "arn:aws:codecommit:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.repository_name}"
    ]
  }
}