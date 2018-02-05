provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
}

module "backend" {
  source = "../modules/backend"

  bootstrap      = "${terraform.workspace == "base" ? 1 : 0}"
  operators      = "${local.operators}"
  bucket         = "${var.bucket}"
  dynamodb_table = "${var.dynamodb_table}"
  key            = "${var.key}"
}
