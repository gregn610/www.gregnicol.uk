provider "aws" {
  # for things like lambda-at-edge which _must_ go to us-east-1
  alias = "use1"
  region = "us-east-1"
}