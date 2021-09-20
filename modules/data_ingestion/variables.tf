variable "env" {
  description = "A variable for environment uniqueness"
  type        = string
}

variable "aws_region" {
  description = "AWS Region where all resources live"
  type        = string
}

# variable "s3_bucket_deployment_packages_id" {
#   description = "ID of the S3 bucket that contains the deployment packages"
#   type        = any
# }