resource "aws_s3_bucket" "incoming_files" {
  bucket = "nga-app-rod-incoming-files-${var.env}"

  acl = "private"
  # logging {
  #   target_bucket = "dcs-s3-access-log-016424107085-us-west-2"
  #   target_prefix = "016424107085-nga-app-rod-incoming-files/"
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
    NAME             = "nga-app-rod-incoming-files-${var.env}"
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

resource "aws_s3_bucket" "invalid_files" {
  bucket = "nga-app-rod-invalid-files-${var.env}"

  acl = "private"
  # logging {
  #   target_bucket = "dcs-s3-access-log-016424107085-us-west-2"
  #   target_prefix = "016424107085-nga-app-rod-invalid-files/"
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
    NAME             = "nga-app-rod-invalid-files-${var.env}"
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

resource "aws_s3_bucket" "valid_files" {
  bucket = "nga-app-rod-valid-files-${var.env}"

  acl = "private"
  # logging {
  #   target_bucket = "dcs-s3-access-log-016424107085-us-west-2"
  #   target_prefix = "016424107085-nga-app-rod-valid-files/"
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
    NAME             = "nga-app-rod-valid-files-${var.env}"
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

resource "aws_s3_bucket_public_access_block" "incoming_files_bucket_block_public_access" {
  bucket = aws_s3_bucket.incoming_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "invalid_files_bucket_block_public_access" {
  bucket = aws_s3_bucket.invalid_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "valid_files_bucket_block_public_access" {
  bucket = aws_s3_bucket.valid_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.incoming_files.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.validate_data_ingestion.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
