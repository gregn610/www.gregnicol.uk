# General
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

variable "cloudfront_origin_path_value_public" {
  type = string
  description = "Value to put in the SSM parameter used for the cloudfront origin path for versioned site updates"
  # NB default is an empty string because SSM doesn't like ""; so always trim it before testing for value
  default = " "
  validation {
    condition     = can(regex("^( |[/].*[^/])$", var.cloudfront_origin_path_value_public))
    error_message = "Must start with a leading slash and not terminate with a slash."
  }
}

# CodeCommit module
variable "default_branch" {
  type        = string
  description = "The name of the default repository branch"
  default     = "main"
}


# CodeBuild module
variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
  type        = string
  default     = "60"
}

variable "build_environment" {
  description = "A map to describe the build environment and populate the environment block"
  type        = map
}

variable "artifact_type" {
  description = "The Artifact type, S3, CODEPIPELINE or NO_ARTIFACT"
  type        = string
  default     = "S3"
}

variable "versioning" {
  type        = bool
  description = "Set bucket to version"
  default     = true
}

# CodePipeline module
variable "deploy_root_key" {
  description = "Optional used in the cloudfront origin path for blue/green deployments"
  type = string
  default = ""
}
variable "deploy_bucket" {
  description = "S3 bucket the site is served from ( behind Cloudfront)"
  type = string
}