
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_id = data.aws_route53_zone.this.zone_id
  records = [
    {
      name = local.subdomain
      type = "A"
      alias = {
        name    = aws_cloudfront_distribution.www.domain_name
        zone_id = aws_cloudfront_distribution.www.hosted_zone_id
      }
    },
  ]
}
