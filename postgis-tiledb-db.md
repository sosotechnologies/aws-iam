## 1. get postgis secret
```sh
kubectl -n bda get secrets postgis-pguser-postgis -o yaml

## decode the objects in the secret
echo "nn" | base64 -d  # dbname and user
echo "nn" | base64 -d  # host
echo "nn" | base64 -d  # port
echo "nn" | base64 -d  # password
```

heres my decoded password: f}PMKFU7b2.^q1UGTHGfiNn[

## 2. Portforward the database 

```sh
PG_CLUSTER_PRIMARY_POD=$(kubectl get pod -n bda -o name \
  -l postgres-operator.crunchydata.com/cluster=postgis,postgres-operator.crunchydata.com/role=master)

kubectl -n bda port-forward "${PG_CLUSTER_PRIMARY_POD}" 5432:5432
```

## 3. Establish a connection to the PostgreSQL cluster.
```sh
kubectl exec -it postgis-instance1-p8tc-0 -n bda -- psql -U postgres
```

## 4. update the postgres user password
```sh
ALTER USER postgres WITH PASSWORD 'secret';
\q
```

## 5. Signin as postgres user
```sh
psql -h localhost -U postgres -d postgres -p 5432
```

## 5. Create DB and grant PRIVILEGES TO postgis
```sh
CREATE DATABASE tiledb;
GRANT ALL PRIVILEGES ON DATABASE tiledb TO postgis;
```

## 6. List databes and users
```sh
\l

### Get the list of users
SELECT usename, usesuper FROM pg_catalog.pg_user WHERE usename = 'postgres';
SELECT usename, usesuper FROM pg_catalog.pg_user WHERE usename = 'postgis';
```

## 7. If required, DROP Database
```sh
DROP DATABASE IF EXISTS tiledb;
```
