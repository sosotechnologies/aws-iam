aws ec2 describe-images --owners amazon --filters "Name=name,Values=bottlerocket-*" --region <your-region>
aws ec2 describe-subnets --filters "Name=tag:karpenter.sh/discovery,Values=mimeo-karpenter-mng"
aws ec2 describe-security-groups --filters "Name=tag:karpenter.sh/discovery,Values=mimeo-karpenter-mng"




kubectl describe serviceaccount -n karpenter karpenter

## Example output:
Annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/KarpenterControllerRole

aws iam get-role --role-name <KarpenterControllerRole> --query "Role.AssumeRolePolicyDocument"


## Make sure the output includes a section that looks like this, where the arn includes the OIDC provider you found earlier:

```json
{
  "Effect": "Allow",
  "Principal": {
    "Federated": "arn:aws:iam::<account-id>:oidc-provider/oidc.eks.<region>.amazonaws.com/id/DE3B5B54FFA16F73828A0AD63F741DEC"
  },
  "Action": "sts:AssumeRoleWithWebIdentity"
}
```

## Step 3: Verify IAM Role Permissions
aws iam list-attached-role-policies --role-name <KarpenterControllerRole>
aws iam attach-role-policy --role-name <KarpenterControllerRole> --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess

##  2. Investigate the SQS Queue Issue
aws iam attach-role-policy --role-name <KarpenterControllerRole> --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess

aws sqs list-queues

aws sqs get-queue-attributes --queue-url <queue-url> --attribute-names Policy
```
