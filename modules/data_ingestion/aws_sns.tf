resource "aws_sns_topic" "data_ingestion" {
  name = "nga-app-rod-data_ingestion"
  tags = {
    ROD = "true"
  }
}

resource "aws_sns_topic_subscription" "data_ingestion_notifications" {
  topic_arn = aws_sns_topic.data_ingestion.arn
  protocol  = "email"
  endpoint  = "rodrodriguez@deloitte.com"
}
