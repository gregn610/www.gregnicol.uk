variable "cloudfront_origin_path_value_public" {
  type        = string
  description = "Preparing for blue/green & lambda-auth later"
  default     = " "
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  # version = "1.5.0"

  aliases = ["${local.subdomain}.${var.domain_name}"]

  comment             = "CloudFront for ${var.resource_name}"
  default_root_object = "${trimspace(var.cloudfront_origin_path_value_public)}/index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    public_bucket  = "${var.resource_name} public access"
  }

  logging_config = {
    bucket = module.logging_bucket.this_s3_bucket_bucket_regional_domain_name
    prefix = "cloudfront/${var.resource_name}"
  }

  origin = {
    public_bucket = {
      domain_name = module.www_bucket.this_s3_bucket_bucket_regional_domain_name
      # ToDo: bug report TF not accepting origin_path with function ???
      origin_path = trimspace(var.cloudfront_origin_path_value_public)
      s3_origin_config = {
        origin_access_identity = "public_bucket" # key in `origin_access_identities`
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "public_bucket"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
    min_ttl         = 0
    default_ttl     = 3600  # 1 hour
    max_ttl         = 43200 # 12 hours
  }

  viewer_certificate = {
    acm_certificate_arn = module.acm.this_acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}
