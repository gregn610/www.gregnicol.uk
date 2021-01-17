generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = var.aws_region
}
provider "aws" {
  # for things like lambda-at-edge which _must_ go to us-east-1
  alias = "aws_us_east_1"
  region = "us-east-1"
}
EOF

}