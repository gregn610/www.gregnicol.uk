data "aws_canonical_user_id" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy" "codecommit_readonly" {
  arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}

locals {
  bucketname = "${local.resource_prefix}-www-${data.aws_caller_identity.current.id}-artifacts"  # This must match up with the naming used inside the module
}
