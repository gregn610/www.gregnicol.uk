locals {
  www_bucket_name     = "www.gregnicol.uk"
  logging_bucket_name = format("%s-logging-%s", local.resource_prefix, data.aws_caller_identity.current.account_id)
}

# www bucket
module "www_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.www_bucket_name
  acl    = "public-read"
  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  logging = {
    target_bucket = module.logging_bucket.this_s3_bucket_id
    target_prefix = "logs/www-bucket/"
  }
}

resource "aws_s3_bucket_ownership_controls" "www_bucket" {
  bucket = module.www_bucket.this_s3_bucket_id

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
  bucket = module.logging_bucket.this_s3_bucket_id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

