# -----------------------------------------------------------------------------
# Outputs: Buckets
# -----------------------------------------------------------------------------
output "www_bucket_name" {
  value = module.www_bucket.this_s3_bucket_id
}
output "logging_bucket_name" {
  value = module.logging_bucket.this_s3_bucket_id
}

# Cloudfront
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.www.id
}
output "cloudfront_s3_origin" {
  value = local.cloudfront_s3_origin_name
}