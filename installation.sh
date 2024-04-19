# Use local server
kubectl config use-context minik-nodes


# Install Sealed-secrets manually
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

cd /opt/repos/stock-cluster

# Create the sealed-secret with the credentials to create to Argo
# Access to the repo
#  /opt/repos/stock-cluster/tools/create_sealed_secret.sh private-repo-creds.unsealed.yaml
#  mv sealed-private-repo-creds.unsealed.yaml private-repo-creds.yaml

# Seal the corresponding ArgoCD private-repo-creds.yaml
kubeseal -f ./applications/argocd/private-repo-creds.unsealed.yaml -w ./applications/argocd/private-repo-creds.yaml

#Run the installation of ArgoCD
kubectl --context minik-nodes apply -f namespace.yaml
kubectl --context minik-nodes apply -k ./environments/development/

# Chek the initial admin password
kubectl get secret -n argocd argocd-initial-admin-secret -o go-template='{{range $k,$v := .data}}{{"### "}}{{$k}}{{"\n"}}{{$v|base64decode}}{{"\n\n"}}{{end}}'

# Port-forward
kubectl -n argocd port-forward deployment/argocd-server 8080:8080
