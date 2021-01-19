
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = data.aws_route53_zone.this.zone_id
  records = [
    {
      name = local.subdomain
      type = "A"
      alias = {
        name    = module.cloudfront.this_cloudfront_distribution_domain_name
        zone_id = module.cloudfront.this_cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}
