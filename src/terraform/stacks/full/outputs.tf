# -----------------------------------------------------------------------------
# Outputs: www-site
# -----------------------------------------------------------------------------
output "www_bucket_name" {
  value = module.www-site.www_bucket_name
}
output "logging_bucket_name" {
  value = module.www-site.logging_bucket_name
}
