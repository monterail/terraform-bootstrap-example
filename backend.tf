terraform {
  backend "s3" {
    bucket = "BUCKET_NAME"
    dynamodb_table = "TerraformStatelock"
    key    = "terraform.tfstate"
    region = "us-west-2"
    profile = "terraform"
  }
}

module "backend" {
  source = "./modules/backend"

  bootstrap = "${terraform.workspace == "default" ? 1 : 0}"
}
