# KMS Key

resource "aws_kms_key" "tf_enc_key" {
  count = "${var.bootstrap}"

  description             = "Global Terraform state encryption key"
  deletion_window_in_days = 30

  tags {
    Origin = "Terraform"
  }
}

# S3 Bucket

resource "aws_s3_bucket" "terraform_state" {
  count = "${var.bootstrap}"

  bucket = "${var.bucket}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.tf_enc_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    Origin = "Terraform"
  }
}

# S3 Bucket Policy

data "aws_iam_user" "operators" {
  count = "${length(var.operators)}"

  user_name = "${var.operators[count.index]}"
}

data "template_file" "operator_arn" {
  count    = "${length(var.operators)}"
  template = "\"$${arn}\""

  vars {
    arn = "${element(data.aws_iam_user.operators.*.arn, count.index)}"
  }
}

data "template_file" "terraform_state_policy" {
  template = "${file("${path.module}/templates/policy.json.tpl")}"

  vars {
    bucket    = "${aws_s3_bucket.terraform_state.arn}"
    key       = "${var.key}"
    operators = "${join(",", data.template_file.operator_arn.*.rendered)}"
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  count = "${var.bootstrap}"

  bucket = "${aws_s3_bucket.terraform_state.id}"
  policy = "${data.template_file.terraform_state_policy.rendered}"
}

# DynamoDB

resource "aws_dynamodb_table" "terraform_statelock" {
  count = "${var.bootstrap}"

  name           = "${var.dynamodb_table}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Origin = "Terraform"
  }
}
