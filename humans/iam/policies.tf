module "admin_policy" {
  source = "../../modules/iam-policy"  # Path to iam-policy module
  name   = "AdminPolicy"
  description = "Admin policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "*"
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

module "read_only_policy" {
  source      = "../../modules/iam-policy"  # Path to iam-policy module
  name        = "ReadOnlyPolicy"
  description = "Read-only policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:Get*",
          "ec2:Describe*",
          "servicecatalog:ListApplications"  # Added permission
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "afacollins2_read_only_policy" {
  user       = module.afacollins2_iam_user.this_iam_user_name
  policy_arn = module.read_only_policy.policy_arn
}