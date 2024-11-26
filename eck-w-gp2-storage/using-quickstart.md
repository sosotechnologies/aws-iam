https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-eck.html
[Doc used for installation](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-service-mesh-istio.html)

### Label the pod for storage-class affinity
```sh
k get no ip-10-0-10-179.ec2.internal --show-labels
k label no ip-10-0-10-179.ec2.internal reserve=elastic-default
```

### create sc-pv-pvc
```sh
kubectl create namespace eck
k apply -f 0-sc-pv-pvc.yaml -n eck 
```

### Download and Apply CRD and Operator

```sh
curl https://download.elastic.co/downloads/eck/2.12.1/crds.yaml > 1-crds.yaml
curl https://download.elastic.co/downloads/eck/2.12.1/operator.yaml > 2-operator.yaml
kubectl apply -f 1-crd.yaml
kubectl apply -f 2-operator.yaml -n elastic-system
```

### Check the configuration and make sure the installation has been successful:
- If the output of the above command contains both [manager] and [istio-proxy], ECK was successfully installed with the Istio sidecar injected.

```sh
kubectl get pod elastic-operator-0 -n elastic-system -o=jsonpath='{range .spec.containers[*]}{.name}{"\n"}'
```

### exclude the inbound port 9443 from being proxied
- edit the template definition of the elastic-operator StatefulSet to add the following annotations to the operator Pod:



### apply the files

```sh
kubectl apply -f 3-elasticsearch.yaml
kubectl apply -f  4-kibana.yaml
kubectl apply -f  4-vs.yaml
```

### Get secrets

```sh
echo echo PASSWORD=$(kubectl -n eck get secret elasticsearch-es-elastic-user  -o go-template='{{.data.elastic | base64decode}}')
```

### Login Credentials
elastic
448ZA965JN7Nvm0Rbh5p0TKl

