resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_user_login_profile" "this" {
  user    = aws_iam_user.this.name
  pgp_key = var.pgp_key
}

output "user_name" {
  value = aws_iam_user.this.name
}

output "encrypted_password" {
  value = aws_iam_user_login_profile.this.encrypted_password
}
