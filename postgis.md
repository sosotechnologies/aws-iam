[github link](https://github.com/CrunchyData/postgres-operator-examples/tree/main/kustomize)

[install](https://access.crunchydata.com/documentation/postgres-operator/latest/quickstart)


```sh
git clone https://github.com/CrunchyData/postgres-operator-examples.git
cd postgres-operator-examples

kubectl apply -k kustomize/install/namespace
kubectl apply --server-side -k kustomize/install/default

kubectl -n postgres-operator get pods \
  --selector=postgres-operator.crunchydata.com/control-plane=postgres-operator \
  --field-selector=status.phase=Running
```

## Next: Create a Postgres Cluster

```sh
kubectl apply -k kustomize/postgres
kubectl -n postgres-operator describe postgresclusters.postgres-operator.crunchydata.com hippo

```

## Connect via psql in the Terminal
psql $(kubectl -n postgres-operator get secrets hippo-pguser-hippo -o go-template='{{.data.uri | base64decode}}')

## Connect Using a Port-Forward
```sh
PG_CLUSTER_PRIMARY_POD=$(kubectl get pod -n postgres-operator -o name \
  -l postgres-operator.crunchydata.com/cluster=hippo,postgres-operator.crunchydata.com/role=master)
kubectl -n postgres-operator port-forward "${PG_CLUSTER_PRIMARY_POD}" 5432:5432
```

### Establish a connection to the PostgreSQL cluster.

```sh
PG_CLUSTER_USER_SECRET_NAME=hippo-pguser-hippo

PGPASSWORD=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.password | base64decode}}') \
PGUSER=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.user | base64decode}}') \
PGDATABASE=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.dbname | base64decode}}') \
psql -h localhost
```

### Create a user schema
CREATE SCHEMA hippo AUTHORIZATION hippo;
