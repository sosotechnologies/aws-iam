apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: ex-xcite-karpenter-nodeclass
spec:
  launchTemplate:
    name: karpenter-2024100821233506110000001a
    version: 1
  subnetSelector:
    karpenter.k8s.aws/subnet-name: ["subnet-05497c7ac8b9bb556", "subnet-001b0067a19ee1a08", "subnet-089cbf70635911107"]
  securityGroupSelector:
    karpenter.k8s.aws/security-group-name: ["sg-0abcd1234abcd5678"]  # Replace with your security group
  instanceProfile: karpenter-eks-node-group-20241008211354150900000002
  tags:
    Name: "karpenter-node"
  instanceTypes: 
    - m5.large
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 20Gi # Disk size as per your launch template (modify if needed)
        volumeType: gp2

---
apiVersion: karpenter.k8s.io/v1alpha5
kind: NodePool
metadata:
  name: ex-xcite-karpenter-nodepool
spec:
  cluster:
    name: ex-xcite-karpenter-1-31
  template:
    spec:
      nodeClass:
        apiVersion: karpenter.k8s.aws/v1
        kind: EC2NodeClass
        name: ex-xcite-karpenter-nodeclass
      taints: []
      labels:
        app: karpenter-node
      kubeletConfiguration:
        maxPods: 110
  scaling:
    minSize: 2
    maxSize: 3
  disallowedInstanceTypes: []   # Add any instance types to restrict
  allowedInstanceTypes: 
    - m5.large
---
cat <<EOF | envsubst | kubectl apply -f - 
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: kubernetes.io/os
          operator: In
          values: ["linux"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand"]  # Your node group is On-Demand
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["m"]  # As you're using m5.large
        - key: karpenter.k8s.aws/instance-generation
          operator: Gt
          values: ["2"]  # Keep it to ensure recent generations
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default
      expireAfter: 720h # 30 * 24h = 720h (customizable)
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized
    consolidateAfter: 1m
---
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: AL2 # Amazon Linux 2, fits your setup
  role: "karpenter-eks-node-group-20241008211354150900000002"  # Your Node IAM role ARN
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: "ex-xcite-karpenter-1-31"  # Replace with your cluster name
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: "ex-xcite-karpenter-1-31"  # Replace with your cluster name
  amiSelectorTerms:
    - id: "ami-1234567890abcdef0"  # Add your specific AMI ID, or omit for default AL2
EOF
---






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
