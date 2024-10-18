# Karpenter for Amazon EKS

## Prerequisites

* You need access to an AWS account with IAM permissions to create an EKS cluster, and an AWS Cloud9 environment if you're running the commands listed in this tutorial.
* Install and configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* Install the [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* (Optional*) Install the [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* (Optional*) Install Helm ([the package manager for Kubernetes](https://helm.sh/docs/intro/install/))

#### Create an EKS Cluster using Terraform
The Terraform template included in this repository is going to create a VPC, an EKS control plane, and a Kubernetes service account along with the IAM role and associate them using IAM Roles for Service Accounts (IRSA) to let Karpenter launch instances. Additionally, the template configures the Karpenter node role to the `aws-auth` configmap to allow nodes to connect, and creates an On-Demand managed node group for the `kube-system` and `karpenter` namespaces.

To create the cluster, clone this repository and then run the following commands:

```sh
cd cluster/terraform
helm registry logout public.ecr.aws
export TF_VAR_region=$AWS_REGION
tofu init
tofu apply -target="module.vpc" -auto-approve
tofu apply -target="module.eks" -auto-approve
tofu apply --auto-approve
```
tofu apply -target="module.efs-module"

Before you continue, you need to enable your AWS account to launch Spot instances if you haven't launch any yet:

```sh
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com || true
```

You might see the following error if the role has already been successfully created. You don't need to worry about this error, you simply had to run the above command to make sure you have the service-linked role to launch Spot instances:

An error occurred (InvalidInput) when calling the CreateServiceLinkedRole operation: Service role name AWSServiceRoleForEC2Spot has been taken in this account, please try a different suffix.
HOTE: Once complete (after waiting about 15 minutes), run the following command to update the `kube.config` file to interact with the cluster through `kubectl`:

```sh
aws eks --region us-east-1 update-kubeconfig --name mimeo-macapenter
```

Make sure you can interact with the cluster and that the Karpenter pods are running:

```sh
$ kubectl get pods -n karpenter

NAME                        READY   STATUS    RESTARTS   AGE
karpenter-9d586dc9c-dvfz8   1/1     Running   0          13m
karpenter-9d586dc9c-mf6xs   1/1     Running   0          13m
```

Next: Deploy the default Karpenter NodePool, and deploy any blueprint you want to test.

#### Deploy a Karpenter Default EC2NodeClass and NodePool

See Links to:
[EC2NodeClass - formelly AWSNodeTemplate ](https://karpenter.sh/preview/concepts/nodeclasses/) 
[NodePool - Formelly Provisioner](https://karpenter.sh/docs/concepts/nodepools/) 

`EC2NodeClass` enable configuration of AWS specific settings for EC2 instances launched by Karpenter. The `NodePool` sets constraints on the nodes that can be created by Karpenter and the pods that can run on those nodes. Each NodePool must reference an `EC2NodeClass` using `spec.nodeClassRef`.

If you create a new EKS cluster following the previous steps, a Karpenter `EC2NodeClass` "default" and a Karpenter `NodePool` "default" are installed automatically.

You can see that the [NodePool] and [EC2NodeClass] has been deployed by running this:

```sh
kubectl get nodepool
kubectl get ec2nodeclass
```

Throughout all the blueprints, you might need to review Karpenter logs using the command:

```sh
kubectl -n karpenter logs -l app.kubernetes.io/name=karpenter --all-containers=true -f --tail=20"
```

You can now proceed to deploy any blueprint you want to test.


### NOTE TO SELF  ####
All the NodePool(s) and EC2NodeClass(es) are applied with tofu and then;
deployments will be applied using kubectl, the deployments will align with the node pools>>
#### tofu Cleanup  (Optional)

Once you're done with testing the blueprints, if you used the tofu template from this repository, you can proceed to remove all the resources that tofu created. To do so, run the following commands:

```
kubectl delete --all nodeclaim
kubectl delete --all nodepool
kubectl delete --all ec2nodeclass
export TF_VAR_region=$AWS_REGION
tofu destroy -target="module.eks_blueprints_addons" --auto-approve
tofu destroy -target="module.eks" --auto-approve
tofu destroy --auto-approve
```

######  If you face issues: here are some troubleshooting commands
## helm failed
kubectl rollout restart deployment aws-load-balancer-controller -n kube-system
terraform apply  --auto-approve


---------------------
helm status karpenter -n karpenter
kubectl get events -n karpenter --sort-by='.metadata.creationTimestamp'
kubectl get serviceaccount karpenter -n karpenter -o yaml


helm history karpenter -n karpenter
helm get all karpenter -n karpenter

## just uninstall the chart, reinstall and then reapply the terraform
helm uninstall karpenter -n karpenter
terraform apply

ORRR

helm install karpenter oci://public.ecr.aws/karpenter/karpenter \
  --version 1.0.1 \
  --namespace karpenter \
  --create-namespace


kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

kubectl get svc -n kube-system aws-load-balancer-webhook-service
kubectl describe svc -n kube-system aws-load-balancer-webhook-service
helm uninstall karpenter -n karpenter
terraform apply


### after karpenter installed, install webhooks dus to webhook issues
kubectl describe secret karpenter-cert kubectl describe secret karpenter-cert -n <namespace>
kubectl describe deployment karpenter kubectl describe secret karpenter-cert -n <namespace>

kubectl get mutatingwebhookconfigurations
kubectl get validatingwebhookconfigurations
kubectl get serviceaccount -n karpenter
kubectl get rolebinding -n karpenter
 kubectl get serviceaccount karpenter -n karpenter -o yaml

kubectl get events -n karpenter
kubectl get crd | grep karpenter
kubectl get deployment karpenter -n karpenter -o=jsonpath='{.spec.template.spec.containers[0].image}'

kubectl get ec2nodeclass
