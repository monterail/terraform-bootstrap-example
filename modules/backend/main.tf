resource "aws_kms_key" "tf_enc_key" {
  count = "${var.bootstrap}"

  description = "Global Terraform state encryption key"
  deletion_window_in_days = 30

  tags {
    Name = "terraform"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  count = "${var.bootstrap}"

  bucket = "BUCKET_NAME"
  acl = "private"
  policy = "${file("./modules/backend/policy.json")}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "expire"
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
    Name = "terraform"
  }
}

resource "aws_dynamodb_table" "terraform_statelock" {
  count = "${var.bootstrap}"

  name = "TerraformStatelock"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "terraform"
  }
}
