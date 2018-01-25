data "aws_iam_user" "operators" {
  count = "${length(var.operators)}"

  user_name = "${var.operators[count.index]}"
}

data "template_file" "operator_arn" {
  count = "${length(var.operators)}"
  template = "\"$${arn}\""

  vars {
    arn = "${element(data.aws_iam_user.operators.*.arn, count.index)}"
  }
}

data "template_file" "terraform_state_policy" {
  template = "${file("${path.module}/policy.json.tpl")}"

  vars {
    bucket = "${aws_s3_bucket.terraform_state.arn}"
    operators = "${join(",", data.template_file.operator_arn.*.rendered)}"
  }
}
