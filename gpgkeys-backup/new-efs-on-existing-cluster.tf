## create an efs on console

## Next...

aws eks describe-nodegroup --cluster-name bda-k8s-world --nodegroup-name cluster-mng --query "nodegroup.resources.remoteAccessSecurityGroup" --output text

aws ec2 describe-instances --filters "Name=tag:eks:nodegroup-name,Values=cluster-mng" --query "Reservations[*].Instances[*].SecurityGroups[*].GroupId" --output text

## Check Current Inbound Rules
aws ec2 describe-security-groups \
    --group-ids sg-0b1fa7fdcfcef6f49 \
    --query "SecurityGroups[*].IpPermissions"


## NOTE:
The output shows that the security group sg-0b1fa7fdcfcef6f49 for the EFS file system allows inbound traffic on port 2049, but only from the CIDR range 10.128.0.0/16. It does not currently permit access specifically from the node group security group sg-07ad29ee168d8cde1.

To allow access from the node group, you’ll need to add a rule to sg-0b1fa7fdcfcef6f49 that allows inbound traffic on port 2049 from sg-07ad29ee168d8cde1. Here’s how to do that:


```sh
aws ec2 authorize-security-group-ingress \
    --group-id sg-0b1fa7fdcfcef6f49 \
    --protocol tcp \
    --port 2049 \
    --source-group sg-07ad29ee168d8cde1
```

##  To verify that the nodes can access the EFS, you could run a mount command from within a pod on your EKS cluster. Here’s a general command you can run within an EKS pod (assuming amazon-efs-utils is installed on the pod’s underlying AMI):

# Replace FILE_SYSTEM_ID and REGION with your actual EFS ID and AWS region.
mount -t efs fs-05cdcdcce6dc0ba8f:/ /mnt/efs
