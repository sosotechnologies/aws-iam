resource "aws_iam_user" "this" {
  name = var.name
  path = "/"
}

resource "aws_iam_user_login_profile" "this_profile" {
  user    = aws_iam_user.this.name
  pgp_key = var.pgp_key
}
