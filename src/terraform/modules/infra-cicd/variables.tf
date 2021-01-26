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

# CodeCommit module
variable "default_branch" {
  type        = string
  description = "The name of the default repository branch"
  default     = "main"
}


# CodeBuild module
variable "build_buildspec" {
  description = "The AWS CodeBuild buildspec as rendered YAML"
  type = string
}

variable "build_codebuild_policy" {
  description = "The IAM policy with _all_ permissions required for all stages of the CodeBuild"
}

variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
  type        = string
  default     = "60"
}

variable "build_environment" {
  description = "A map to describe the build environment and populate the environment block"
  type        = any  # was map of strings but couldn't pass build  .environment_variables
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
