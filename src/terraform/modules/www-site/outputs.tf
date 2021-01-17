# -----------------------------------------------------------------------------
# Outputs: Buckets
# -----------------------------------------------------------------------------
output "www_bucket_name" {
  value = module.www_bucket.this_s3_bucket_id
}
output "logging_bucket_name" {
  value = module.logging_bucket.this_s3_bucket_id
}
