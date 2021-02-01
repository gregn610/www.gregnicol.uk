locals {
  www_bucket_name             = "www.gregnicol.uk"
  logging_bucket_name         = format("%s-logging-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
  use1_deployment_bucket_name = format("%s-use1-deploy-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
}

# www bucket
module "www_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.www_bucket_name
  acl    = "private"
  attach_policy = true
  policy = data.aws_iam_policy_document.s3_secured_oai_policy.json

  logging = {
    target_bucket = module.logging_bucket.this_s3_bucket_id
    target_prefix = "logs/www-bucket/"
  }

  versioning = {
    enabled = true
  }
}

resource "aws_s3_bucket_ownership_controls" "www_bucket" {
  bucket = local.www_bucket_name
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Logging bucket
module "logging_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = local.logging_bucket_name
  acl                     = "log-delivery-write"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_logging_bucket" {
  bucket = local.logging_bucket_name
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# US East 1 lambda@edge deployment bucket
module "use1_deployment_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  providers = {
    aws = aws.use1
  }

  bucket                  = local.use1_deployment_bucket_name
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "use1_deployment_bucket" {
  provider = aws.use1

  bucket = local.use1_deployment_bucket_name
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

