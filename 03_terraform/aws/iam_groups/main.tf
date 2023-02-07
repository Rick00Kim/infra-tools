resource "aws_iam_group" "iam_group" {
  name = var.group-name
}

resource "aws_iam_role_policy" "new_iac_role_policy" {
  name   = "${var.role-name}_policy"
  role   = aws_iam_role.new_iac_role.id
  policy = file("${path.module}/rolePolicy.json")
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.iam_group.group.name
  policy_arn = aws_iam_role_policy.new_iac_role_policy.policy.arn
}
