output "s3_bucket_valid_files" {
  description = "S3 bucket where valid files are stored"
  value       = aws_s3_bucket.valid_files.bucket
}