## if you see error
error (exit code 1): pods "s3-list-buckets" is forbidden: User "system:serviceaccount:argo-workflows:default" cannot patch resource "pods" in API group "" in the namespace "argo-workflows"

## it means
indicates that the ServiceAccount used by your Argo Workflow (system:serviceaccount:argo-workflows:default) does not have sufficient permissions to patch pods in the argo-workflows namespace. This is a Kubernetes Role-Based Access Control (RBAC) issue.

```sh
# get the sa: default
k get sa -n argo-workflows
```

### create role and clusterrole
```sh
k -n argo-workflows apply -f role.yaml  
k -n argo-workflows apply -f rolebinding.yaml
```