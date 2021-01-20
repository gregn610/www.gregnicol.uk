
variable "domain_name" {
  type        = string
  description = "The domain name to use when creating certificates, route53 & cloudfront resources, eg. example.com"
}

variable "env_name" {
  type        = string
  description = "The environment name to use when prefixing and tagging resources. eg. (dev|staging|prod)"
}

variable "resource_name" {
  type        = string
  description = "Used in resource names and tags. eg. gregnicoluk"
}

variable "common_tags" {
  type        = map
  description = "Common AWS resource tags"
  default     = {}
}
