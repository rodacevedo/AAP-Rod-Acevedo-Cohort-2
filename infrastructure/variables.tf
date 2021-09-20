variable "env" {
  description = "A variable for environment uniqueness"
  type        = string
  default     = "rodnga"
}

variable "aws_region" {
  description = "AWS Region where all resources live"
  type        = string
  default     = "us-west-2"
}