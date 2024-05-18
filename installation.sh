# Use local server
kubectl config use-context minik-nodes


# Install Sealed-secrets manually
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets


# Create the sealed-secret with the credentials to create to Argo
# https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-repo-creds-yaml/
# Access to the repo
echo "CHECK THE VAULT"
cd /opt/repos/stock-cluster/environments/development
/opt/repos/stock-cluster/tools/create_sealed_secret.sh private-repo-creds.unsealed.yaml
mv sealed-private-repo-creds.unsealed.yaml /Volumes/TOSHIBA01/projectskubernetes/repos/stock-cluster/applications/argocd/private-repo-creds.yaml


# Seal the corresponding ArgoCD private-repo-creds.yaml
# kubeseal -f /opt/repos/stock-cluster/environments/development/argocd/private-repo-creds.unsealed.yaml \
# -w /opt/repos/stock-cluster/environments/development/argocd/private-repo-creds.yaml

#Run the installation of ArgoCD
kubectl --context minik-nodes apply -k /opt/repos/stock-cluster/applications/argocd
kubectl --context minik-nodes apply -k /opt/repos/stock-cluster/environments/development

# Chek the initial admin password
kubectl get secret -n argocd argocd-initial-admin-secret -o go-template='{{range $k,$v := .data}}{{"### "}}{{$k}}{{"\n"}}{{$v|base64decode}}{{"\n\n"}}{{end}}'

# Port-forward
kubectl -n argocd port-forward deployment/argocd-server 8080:8080
