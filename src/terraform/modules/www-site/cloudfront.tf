variable "cloudfront_origin_path_value_public" {
  type        = string
  description = "Preparing for blue/green & lambda-auth later"
  default     = " "
}

resource "aws_s3_bucket_policy" "s3_secured_oai_policy" {
  bucket = module.www_bucket.this_s3_bucket_id
  policy = data.aws_iam_policy_document.s3_secured_oai_policy.json
}

resource "aws_cloudfront_origin_access_identity" "www_s3" {
  comment = local.resource_prefix
}

resource "aws_cloudfront_distribution" "www" {
  # Not using aws-terraform-module because blue/green needs a lifecycle ignore on origin_path
  lifecycle {
    ignore_changes = [
      origin  # Gah!, can't narrow this down to ["public_bucket"]["origin_path"]
                               # https://github.com/hashicorp/terraform/issues/22504
    ]
  }

  aliases             = ["${local.subdomain}.${var.domain_name}"]
  comment             = "CloudFront for ${var.resource_name}"
  default_root_object = var.default_root_object
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  logging_config {
    bucket = module.logging_bucket.this_s3_bucket_bucket_regional_domain_name
    prefix = "cloudfront/${var.resource_name}"
  }

  origin {
    origin_id   = local.cloudfront_s3_origin_name
    domain_name = module.www_bucket.this_s3_bucket_bucket_regional_domain_name
    # ToDo: bug report TF not accepting origin_path with function ???
    origin_path = trimspace(var.cloudfront_origin_path_value_public)
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.www_s3.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = local.cloudfront_s3_origin_name
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    min_ttl         = 0
    default_ttl     = 3600  # 1 hour
    max_ttl         = 43200 # 12 hours
  }

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU", "CN", "UA"]
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.2_2019"
    acm_certificate_arn      = module.acm.this_acm_certificate_arn
    ssl_support_method       = "sni-only"
  }
}
