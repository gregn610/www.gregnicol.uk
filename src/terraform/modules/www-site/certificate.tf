
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.0"

  domain_name               = var.domain_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = [
    "${local.subdomain}.${var.domain_name}",
    "*.${var.domain_name}"
  ]
}
