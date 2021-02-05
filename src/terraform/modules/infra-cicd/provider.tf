# Lambda@Edge insists on us-east-1 which knocks on, so just do the whole module
provider "aws" {
  region = "us-east-1"
}
