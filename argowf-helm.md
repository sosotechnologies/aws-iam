## helm
https://github.com/argoproj/argo-helm

helm repo add argo https://argoproj.github.io/argo-helm
helm search repo argo
helm pull argo/argo-workflows --untar=true
helm -n argo install argowf  argo-workflows/
kubectl -n argo port-forward svc/argowf-argo-workflows-server 2746:2746
kubectl -n argo exec $( kubectl get pods -n argo -o jsonpath='{.items[0].metadata.name}' ) -- argo auth token


## implement irsa
https://github.com/aws-ia/terraform-aws-eks-blueprints-addon.git

# EFS
## SteP 1 create a role, policy and service account if you dont already have
Get the IAM OIDC provider for your cluster 

```sh
cluster_name=mimeo-karpenter

oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

echo $oidc_id
# Determine whether an IAM OIDC provider with your cluster's issuer ID is already in your account.
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
```

## SteP 2 Create the IAM Policy
### 2.1. Create the IAM Policy
- Create a policy JSON file called [argowf-policy.json] with the following contents:


### 2.2 Create the IAM Policy in AWS
```sh
aws iam create-policy \
    --policy-name argowf-mimeo-policy \
    --policy-document file://argowf-policy.json
```

### 2.3. Attach the IAM Policy to Your Role
```sh
aws iam attach-role-policy \
    --role-name mimeo-argowf-manaul-role \
    --policy-arn arn:aws:iam::368085106192:policy/argowf-mimeo-policy
```

### 2.4. Verify the Policy is Attached
```sh
aws iam list-attached-role-policies \
    --role-name mimeo-argowf-manaul-role
```

## Step 3 - and and Assign IAM roles to Kubernetes service accounts 
create a service account for the efs called: [argo-infra]
I already have a role that I will use called: [mimeo-argowf-manaul-role]

### Update the Assume Role Policy
- veryfy the role:

```sh
aws iam get-role --role-name mimeo-argowf-manaul-role
```

- put the below json code in a file: assume-role-policy.json

```sh
nano assume-role-policy.json
```

***To update the role's trust policy, you can use the following command:*** 

```sh
aws iam update-assume-role-policy --role-name mimeo-argowf-manaul-role --policy-document file://assume-role-policy.json

aws iam get-role --role-name mimeo-argowf-manaul-role | jq '.Role.AssumeRolePolicyDocument'
```

### Now create the SA yaml with the name of the role:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argo-infra
  namespace: argo
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::368085106192:role/mimeo-argowf-manaul-role
```


## Step 5: upgrade the chart

```sh
helm upgrade -i argowf  argo-workflows \
    --namespace argo \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=argo-infra

```

### or if already deployed, edit the service accounts to argo-infra
```sh
k edit deploy argo-server -n argo
k edit deploy workflow-controller -n argo
```

### get the resources
```sh
k -n kube-system get sa argo-infra
k -n kube-system get deploy efs-csi-controller
```

