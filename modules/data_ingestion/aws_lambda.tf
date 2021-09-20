resource "aws_iam_role" "iam_for_lambda" {
  name = "nga-app-rod-iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "nga-app-rod-iam_for_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*",
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_access" {
  name        = "nga-app-rod-iam_for_lambda_s3_access"
  path        = "/"
  description = "IAM policy to get and put s3 objects from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Put*",
        ],
        Effect   = "Allow",
        Resource = "*",
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_sns_access" {
  name        = "nga-app-rod-iam_for_lambda_sns_access"
  path        = "/"
  description = "IAM policy for publish to sns topics from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:Publish"
        Effect   = "Allow",
        Resource = "arn:aws:sns:us-west-2:251074187312:*",
      }
    ]
  })
}

resource "aws_lambda_function" "validate_data_ingestion" {
  function_name = "validate_data_ingestion"
  role          = aws_iam_role.iam_for_lambda.arn

  description      = "Validates and transfer incoming files"
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  filename         = "../../fn_test_lambda.zip"
  source_code_hash = filebase64sha256("../../fn_test_lambda.zip")

  # s3_bucket = var.s3_bucket_deployment_packages_id
  # s3_key    = "fn_validate_data_ingestion.zip"
  # #s3_object_version = 

  environment {
    variables = {
      aws_region        = var.aws_region,
      s3_incoming_files = aws_s3_bucket.incoming_files.bucket,
      s3_invalid_files  = aws_s3_bucket.invalid_files.bucket,
      s3_valid_files    = aws_s3_bucket.valid_files.bucket,
      sns_topic_arn     = aws_sns_topic.data_ingestion.arn,
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_s3_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sns" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_sns_access.arn
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.validate_data_ingestion.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.incoming_files.arn
}
