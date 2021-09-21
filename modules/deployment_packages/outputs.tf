output "s3_bucket_deployment_packages_id" {
  description = "ID of the S3 bucket that contains the deployment packages"
  value       = aws_s3_bucket.deployment_packages.id
}