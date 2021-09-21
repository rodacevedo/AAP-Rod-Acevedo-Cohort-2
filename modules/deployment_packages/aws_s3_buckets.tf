resource "aws_s3_bucket" "deployment_packages" {
  bucket = "nga-app-rod-deployment-package-${var.env}"

  acl = "private"
  # logging {
  #   target_bucket = "dcs-s3-access-log-016424107085-us-west-2"
  #   target_prefix = "016424107085-nga-app-rod-deployment_packages/"
  # }
  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    NAME             = "nga-app-rod-deployment-packages-${var.env}"
    ROD              = "true"
    BILLINGCODE      = "FPE01927-PX-21-21-2008"
    BILLINGCONTACT   = "Stefan Kircher"
    COUNTRY          = "US"
    CSCLASS          = "Public"
    CSQUAL           = "Synthetic/Dummy Data"
    CSTYPE           = "Internal"
    ENVIRONMENT      = "NPD"
    FUNCTION         = "CON"
    MEMBERFIRM       = "US"
    PRIMARYCONTACT   = "timkelly@deloitte.com"
    SECONDARYCONTACT = "Evan Kaliner"
  }
}

resource "aws_s3_bucket_public_access_block" "deployment_packages_bucket_block_public_access" {
  bucket = aws_s3_bucket.deployment_packages.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}