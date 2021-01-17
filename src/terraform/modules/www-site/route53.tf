
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = "www"
      type = "A"
      alias = {
        name    = module.www_bucket.this_s3_bucket_website_domain
        zone_id = module.www_bucket.this_s3_bucket_hosted_zone_id
      }
    },
  ]
}
