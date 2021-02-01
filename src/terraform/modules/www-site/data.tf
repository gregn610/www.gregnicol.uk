data "aws_canonical_user_id" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name = var.domain_name
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
