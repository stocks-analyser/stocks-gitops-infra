
# Sealed Secrets
## Install Sealed-secrets manually

    helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets

    helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

## Create private-repo-creds sealed secret
    ./create_sealed_secret.sh private-repo-creds.unsealed.secret.yaml

<br><br>

# ArgoCD
## Run the installation of ArgoCD

    kubectl apply -k /Users/alejandroprieto/projects/stocks-gitops-infra/applications/argocd

    # kubectl apply -k /Users/alejandroprieto/projects/stocks-gitops-infra/environments/development

## Check the initial admin password

    kubectl get secret -n argocd argocd-initial-admin-secret -o go-template='{{range $k,$v := .data}}{{"### "}}{{$k}}{{"\n"}}{{$v|base64decode}}{{"\n\n"}}{{end}}'

## For exposing argocd login - check the traefik configuration instructions
#### install the traefik ingress route

    kubectl apply -k /Users/alejandroprieto/projects/stocks-gitops-infra/applications/traefik 
    
### Port-forward
    # kubectl -n argocd port-forward deployment/argocd-server 8080:8080

## Remove ArgoCD

    kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    kubectl delete ns argocd 

<br><br>
### Get all the resources associated to namespace:

    kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n argocd

<br><br>

# CI - Configuration
## Runner configuration
    https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/adding-self-hosted-runners

    cd projects/actions-runner 
    ./run.sh
