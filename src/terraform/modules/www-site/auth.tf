
module "lambda_cloudfront_auth" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.31.0"
  providers = {
    aws = aws.use1  # Lambda@Edge must go to us-east-1
  }

  function_name  = local.cloudfront_auth_lambda_name
  handler        = local.cloudfront_auth_lambda_handler
  runtime        = local.cloudfront_auth_lambda_runtime
  publish        = true
  create_package = false
  lambda_at_edge = true
  attach_policy  = true # The module seems to be missing some create CW loggroup permissions at the moment
  policy         = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  s3_existing_package = {
    bucket = module.use1_deployment_bucket.this_s3_bucket_id
    key    = local.cloudfront_auth_lambda_key
  }

  allowed_triggers = {
    Lambda = {
      service = "lambda"
    }
    EdgeLambda = {
      service = "edgelambda"
    }
  }
}
