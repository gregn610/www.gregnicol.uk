# -----------------------------------------------------------------------------
# Outputs: Buckets
# -----------------------------------------------------------------------------
output "www_bucket_name" {
  value = module.www_bucket.this_s3_bucket_id
}
output "logging_bucket_name" {
  value = module.logging_bucket.this_s3_bucket_id
}
output "use1_deployment_bucket" {
  value = module.use1_deployment_bucket.this_s3_bucket_id
}

# Cloudfront
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.www.id
}
output "cloudfront_s3_origin" {
  value = local.cloudfront_s3_origin_name
}
# -----------------------------------------------------------------------------
# Outputs: Cognito
# -----------------------------------------------------------------------------

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "cognito_user_pool_arn" {
  value = aws_cognito_user_pool.user_pool.arn
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.site_client.id
}
