provider "aws" {
  profile = "terraform"
  region = "${local.aws_region}"
}
