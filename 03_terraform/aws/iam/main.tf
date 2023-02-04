resource "aws_iam_role" "new_iac_role" {
  name               = var.role-name
  assume_role_policy = file("${path.module}/assumePolicy.json")
}

resource "aws_iam_role_policy" "new_iac_role_policy" {
  name   = "${var.role-name}_policy"
  role   = aws_iam_role.new_iac_role.id
  policy = file("${path.module}/rolePolicy.json")
}
