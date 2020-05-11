locals {
  operators = [
    # Put any local operator IAM user names here
  ]
}

variable "bucket" {
  description = "AWS S3 Bucket name for Terraform state"
}
variable "dynamodb_table" {
  description = "AWS DynamoDB table for state locking"
}
variable "key" {
  description = "Key for Terraform state at S3 bucket"
}
variable "profile" {
  description = "AWS profile"
}
variable "region" {
  description = "AWS Region"
}
