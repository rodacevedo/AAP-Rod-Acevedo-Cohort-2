terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# module "deployment_packages" {
#   source = "../modules/deployment_packages"
#   env    = var.env
# }

module "data_ingestion" {
  source     = "../modules/data_ingestion"
  env        = var.env
  aws_region = var.aws_region
  # s3_bucket_deployment_packages_id = module.deployment_packages.s3_bucket_deployment_packages_id
}

module "data_conversion" {
  source                = "../modules/data_conversion"
  s3_bucket_valid_files = module.data_ingestion.s3_bucket_valid_files
}

module "data_consumption" {
  source = "../modules/data_consumption"
}

module "interface_providers" {
  source = "../modules/interface_providers"
  env    = var.env
}

module "interface_workers" {
  source = "../modules/interface_workers"
}