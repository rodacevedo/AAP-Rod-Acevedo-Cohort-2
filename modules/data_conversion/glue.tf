#create IAM role and attach a policy to access S3
resource "aws_iam_role" "iam_for_glue" {
  name = "nga-app-rod-iam_for_glue"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "glue_all_access" {
  name        = "nga-app-rod-iam_for_glue__access"
  path        = "/"
  description = "IAM policy to get S3 objects from glue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glue:*",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeRouteTables",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcAttribute",
          "iam:ListRolePolicies",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "cloudwatch:PutMetricData"
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action = [
          "s3:Get*",
          "s3:List*",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:AssociateKmsKey"
        ],
        Resource = "arn:aws:logs:*:*:*",
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_access" {
  role       = aws_iam_role.iam_for_glue.name
  policy_arn = aws_iam_policy.glue_all_access.arn
}

#create glue catalog database
resource "aws_glue_catalog_database" "catalog_database" {
  name        = "rod_nga_catalog_database"
  description = "database to organize all incoming files metadata into tables"
}

#create glue crawler
resource "aws_glue_crawler" "s3_bucket_crawler" {
  name          = "s3_bucket_crawler"
  database_name = aws_glue_catalog_database.catalog_database.name
  role          = aws_iam_role.iam_for_glue.arn


  # recrawl_policy {
  #   recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
  # }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "LOG"
  }

  s3_target {
    path = "s3://${var.s3_bucket_valid_files}/persons"
  }

  s3_target {
    path = "s3://${var.s3_bucket_valid_files}/personServices"
  }

  s3_target {
    path = "s3://${var.s3_bucket_valid_files}/providers"
  }

  s3_target {
    path = "s3://${var.s3_bucket_valid_files}/services"
  }

  #   catalog_target {
  #     database_name = aws_glue_catalog_database.example.name
  #     tables        = [aws_glue_catalog_table.example.name]
  #   }
}
