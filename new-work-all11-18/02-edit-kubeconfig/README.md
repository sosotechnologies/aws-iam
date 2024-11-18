## edit config file and add users
```sh
kubectl edit configmap aws-auth -n kube-system
```

```yaml
mapUsers: |
    - "userarn": "arn:aws:iam::126924000548:user/tofu-admin"
      "username": "tofu-admin"
      "groups":
        - "system:masters"
    - "userarn": "arn:aws:iam::126924000548:user/marc.ellens@capgemini-gs.com"
      "username": "marc.ellens@capgemini-gs.com"
      "groups":
        - "system:masters"
```

