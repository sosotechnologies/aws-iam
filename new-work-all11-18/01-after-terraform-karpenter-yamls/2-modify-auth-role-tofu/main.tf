resource "aws_iam_policy" "mimeo_policy" {
  name        = "mimeo-initial-eks-node-policy"
  description = "Policy with ECR, IAM, CloudWatch, S3, and other permissions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRPermissions"
        Effect   = "Allow"
        Action   = [
          "ecr:*",
          "cloudtrail:LookupEvents",
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:DescribeImageReplicationStatus",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:BatchDeleteImage",
          "ecr:ListImages",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:DeleteRepository",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource",
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:ReplicateImage",
          "ecr:GetLifecyclePolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:PutImageScanningConfiguration",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImage",
          "ecr:UntagResource",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:StartLifecyclePolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:GetRepositoryPolicy"
        ]
        Resource = "*"
      },
      {
        Sid      = "ECRRegistryPermissions"
        Effect   = "Allow"
        Action   = [
          "ecr:GetRegistryPolicy",
          "ecr:BatchImportUpstreamImage",
          "ecr:CreateRepository",
          "ecr:DescribeRegistry",
          "ecr:DescribePullThroughCacheRules",
          "ecr:GetAuthorizationToken",
          "ecr:PutRegistryScanningConfiguration",
          "ecr:CreatePullThroughCacheRule",
          "ecr:DeletePullThroughCacheRule",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:PutReplicationConfiguration"
        ]
        Resource = "*"
      },
      {
        Sid      = "IAMServiceLinkedRole"
        Effect   = "Allow"
        Action   = "iam:CreateServiceLinkedRole"
        Resource = "*"
        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = "replication.ecr.amazonaws.com"
          }
        }
      },
      {
        Sid      = "IAMGetRole"
        Effect   = "Allow"
        Action   = "iam:GetRole"
        Resource = "arn:aws:iam::*:role/aws-service-role/application-signals.cloudwatch.amazonaws.com/AWSServiceRoleForCloudWatchApplicationSignals"
      },
      {
        Sid      = "CloudWatchReadOnly"
        Effect   = "Allow"
        Action   = [
          "application-autoscaling:DescribeScalingPolicies",
          "application-signals:BatchGet*",
          "application-signals:Get*",
          "application-signals:List*",
          "autoscaling:Describe*",
          "cloudwatch:BatchGet*",
          "cloudwatch:Describe*",
          "cloudwatch:GenerateQuery",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "logs:Get*",
          "logs:List*",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:Describe*",
          "logs:TestMetricFilter",
          "logs:FilterLogEvents",
          "logs:StartLiveTail",
          "logs:StopLiveTail",
          "oam:ListSinks",
          "sns:Get*",
          "sns:List*",
          "rum:BatchGet*",
          "rum:Get*",
          "rum:List*",
          "synthetics:Describe*",
          "synthetics:Get*",
          "synthetics:List*",
          "xray:BatchGet*",
          "xray:Get*"
        ]
        Resource = "*"
      },
      {
        Sid      = "OAMReadPermissions"
        Effect   = "Allow"
        Action   = "oam:ListAttachedLinks"
        Resource = "arn:aws:oam:*:*:sink/*"
      },
      {
        Sid      = "S3Permissions"
        Effect   = "Allow"
        Action   = [
          "s3:PutAnalyticsConfiguration",
          "s3:DeleteAccessPoint",
          "s3:CreateBucket",
          "s3:GetBucketObjectLockConfiguration",
          "s3:DeleteBucketWebsite",
          "s3:GetIntelligentTieringConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketWebsite",
          "s3:PutReplicationConfiguration",
          "s3:GetBucketNotification",
          "s3:PutBucketCORS",
          "s3:GetReplicationConfiguration",
          "s3:PutBucketNotification",
          "s3:PutBucketLogging",
          "s3:GetAnalyticsConfiguration",
          "s3:PutBucketObjectLockConfiguration",
          "s3:CreateAccessPoint",
          "s3:GetLifecycleConfiguration",
          "s3:GetInventoryConfiguration",
          "s3:GetBucketTagging",
          "s3:PutAccelerateConfiguration",
          "s3:GetBucketLogging",
          "s3:ListBucketVersions",
          "s3:ListBucket",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketPolicy",
          "s3:PutEncryptionConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::bda*/*",
          "arn:aws:s3:::bda*",
          "arn:aws:s3:::blob-storage-ingest*/*",
          "arn:aws:s3:::blob-storage-ingest*",
          "arn:aws:s3:::blob-storage-assets*/*",
          "arn:aws:s3:::blob-storage-assets*",
          "arn:aws:s3:::argo-storage-logs*/*",
          "arn:aws:s3:::argo-storage-logs*",
          "arn:aws:s3:*:126924000548:accesspoint/*"
        ]
      },
      {
        Sid      = "S3GlobalPermissions"
        Effect   = "Allow"
        Action   = [
          "s3:ListAllMyBuckets",
          "s3:GetAccountPublicAccessBlock",
          "s3:GetBucketAcl",
          "s3:GetBucketPolicyStatus",
          "s3:GetObjectAcl",
          "s3:GetBucketLocation",
          "s3:GetAccessPoint"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "mimeo_policy_attachment" {
  role       = "mg_5-eks-node-group-20241117130542508300000002"
  policy_arn = aws_iam_policy.mimeo_policy.arn
}

## 