# Use local server
kubectl config use-context minik-nodes


# Install Sealed-secrets manually
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

# Seal the corresponding ArgoCD private-repo-creds.yaml
kubeseal ./applications/argocd/private-repo-creds.unsealed.yaml -w ./applications/argocd/private-repo-creds.yaml

#Run the installation of ArgoCD
kubectl --context minik-nodes apply -k ./environments/development/

