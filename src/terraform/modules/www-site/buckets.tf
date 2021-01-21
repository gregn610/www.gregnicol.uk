locals {
  www_bucket_name     = "www.gregnicol.uk"
  logging_bucket_name = format("%s-logging-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
}

data "aws_iam_policy_document" "s3_secured_oai_policy" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
       module.www_bucket.this_s3_bucket_arn,
      "${module.www_bucket.this_s3_bucket_arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.www_s3.iam_arn]
    }
  }
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

