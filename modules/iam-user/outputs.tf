output "this_iam_user_name" {
  value = aws_iam_user.this.name
}


output "encrypted_password" {
  value = aws_iam_user_login_profile.this_profile.encrypted_password
}
