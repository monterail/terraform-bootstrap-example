module "backend" {
  source = "../modules/backend"

  bootstrap = 1
  operators = "${var.aws_operators}"
}
