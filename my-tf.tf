provider "aws" {
  region = "us-east-1"
}

# Create IAM Policy to allow assuming the admin-weekend role
module "iam_policy_assume_admin" {
  source      = "../../modules/iam-policy"
  
  create_policy = true
  name          = "AllowAssumeAdminWeekend"
  description   = "Policy to allow assuming the admin-weekend role"
  policy        = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = "arn:aws:iam::368085106192:role/admin-weekend"  
      }
    ]
  })
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}

# Create the admin-weekend role with a trust policy
module "iam_assumable_role_admin_weekend" {
  source                     = "../../modules/iam-assumable-role"

  create_role               = true
  role_name                 = "admin-weekend"
  role_requires_mfa         = false 
  trusted_role_arns         = [
    "arn:aws:iam::307990089504:root",
    "arn:aws:iam::368085106192:user/terraform-admin"
  ]
  admin_role_policy_arn     = "arn:aws:iam::aws:policy/AdministratorAccess"
  tags                      = {
    Environment = "dev"
    Project     = "my-project"
  }
}
##################

# Policy for S3 access (attach to the existing role)
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy to allow listing and reading from S3 buckets"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the S3 access policy to the admin-weekend role
resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = "admin-weekend"  # Attach to the admin-weekend role
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Additional policy for frontenders
module "iam_policy_frontenders" {
  source      = "../../modules/iam-policy"
  
  create_policy = true
  name          = "AllowFrontendersToAssumeRole"
  description   = "Policy for Frontenders"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = "*"
      }
    ]
  })
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}

# Attach the frontenders S3 access policy to the admin-weekend role
resource "aws_iam_role_policy_attachment" "attach_frontenders_policy" {
  role       = "admin-weekend"
  policy_arn = module.iam_policy_frontenders.arn
}
################
# outputs.tf
output "terraform_user_role_arn" {
  description = "The ARN of the Terraform user role"
  value       = module.iam_assumable_role_admin_weekend.iam_role_arn  # Update to match the correct module name
}

output "terraform_policy_arn" {
  description = "The ARN of the policy for assuming the admin-weekend role"
  value       = module.iam_policy_assume_admin.arn  # Update to match the correct module name
}


