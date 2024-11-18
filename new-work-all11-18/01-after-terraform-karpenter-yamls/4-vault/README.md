helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm pull hashicorp/vault --untar=true
kubectl create ns vault

## Edit the values.yaml file with the storage objects

## create the sc  and pv

## deploy vault
```sh
helm -n vault install vault hashicorp/vault --set "injector.enabled=false" --set "server.dataStorage.enabled=true" --set "server.dataStorage.size=5Gi" --set "server.dataStorage.storageClass=efs-sc"

helm -n vault install vault hashicorp/vault --set "injector.enabled=false" --set "server.dataStorage.enabled=true" --set "server.dataStorage.size=5Gi" --set "server.dataStorage.storageClass=gp2"
```

```sh
kubectl -n vault get pods
```

#################################
# Configure Vault as a certificate manager in Kubernetes with Helm
[Link:](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-cert-manager)
[Not related, but good resource](https://cert-manager.io/docs/configuration/vault/)

##  start unealing vault 

```sh
kubectl -n vault exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 \
      -format=json > init-keys.json
```

```sh
cat init-keys.json | jq -r ".unseal_keys_b64[]" 

VAULT_UNSEAL_KEY=$(cat init-keys.json | jq -r ".unseal_keys_b64[]")

kubectl -n vault exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY

kubectl -n vault get pods
```

## expose the service to LB
- I already have metallb installed for LoadBalancing

```sh
kubectl -n vault get svc 
kubectl patch svc vault -n vault -p '{"spec": {"type": "LoadBalancer"}}'
```

## get the token and sign in
```sh
cat init-keys.json | jq -r ".root_token"
```

## exec in the pod
```sh
kubectl -n vault exec -it vault-0 -- /bin/sh
```

## Run commands
```sh
export VAULT_ADDR=http://10.0.0.25:8200/
export VAULT_TOKEN=hvs.HTCURjssUCbasGTjtPyCYm2m
vault login $VAULT_TOKEN
```

## Enable the PKI secrets engine at its default path.
```sh
vault secrets enable pki
vault secrets tune -max-lease-ttl=8760h pki
```

## Generate a self-signed certificate valid for 8760h.
- This will create a Certificate, Issuer, key

```sh
vault write pki/root/generate/internal \
    common_name=angelpalms.com \
    ttl=8760h
```

## Configure the PKI secrets engine certificate issuing and certificate revocation list (CRL) endpoints to use the Vault service in the default namespace.

```sh
vault write pki/config/urls \
    issuing_certificates="http://10.0.0.25:8200/v1/pki/ca" \
    crl_distribution_points="http://10.0.0.25:8200/v1/pki/crl"
```

## Configure a role named angelpalms-role that enables the creation of certificates angelpalms.com domain with any subdomains.

```sh
vault write pki/roles/angelpalms-role \
    allowed_domains=angelpalms.com \
    allow_subdomains=true \
    max_ttl=72h
```

## Create a policy named pki that enables read access to the PKI secrets engine paths.

```sh
vault policy write pki - <<EOF
path "pki*"                        { capabilities = ["read", "list"] }
path "pki/sign/angelpalms-role"    { capabilities = ["create", "update"] }
path "pki/issue/angelpalms-role"   { capabilities = ["create"] }
EOF
```

##  exit the vault-0 pod.
```sh
exit
```

# NEXT: Configure Kubernetes authentication

## Re-exec in the pod 

```sh
kubectl -n vault exec -it vault-0 -- /bin/sh
```

## Enable the Kubernetes authentication method.

```sh
vault auth enable kubernetes
```

## Configure the Kubernetes authentication method to use location of the Kubernetes API.

```sh
vault write auth/kubernetes/config \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
```

## Create a Kubernetes authentication role named issuer that binds the pki policy with a Kubernetes service account named issuer.
```sh
vault write auth/kubernetes/role/issuer \
    bound_service_account_names=issuer \
    bound_service_account_namespaces=default \
    policies=pki \
    ttl=20m
```

## Exit
```sh
exit
```

# Deploy Cert Manager - Jetstack's cert-manager

## Install Jetstack's cert-manager's version 1.12.3 resources.

```sh
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.14.5/cert-manager.crds.yaml
```

## Create a namespace named cert-manager to host the cert-manager.
```sh
kubectl create namespace cert-manager
```

## Add the jetstack chart repository.
```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
