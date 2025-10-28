
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

## PgAdmin
### Install-cnpg-plugin 
    curl -sSfL \                  
      https://github.com/cloudnative-pg/cloudnative-pg/raw/main/hack/install-cnpg-plugin.sh | \
      sudo sh -s -- -b /usr/local/bin

### Install pgadmin
    kubectl cnpg pgadmin4 --mode desktop cluster-dev -n pgdb

#### To remove pgadmin:
    kubectl cnpg -n pgdb pgadmin4 cluster-dev --dry-run | kubectl delete -f -
  

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

## Install runner - secure

    sudo useradd -m -d /opt/actions-runner -s /bin/bash actions

    sudo passwd -l actions  # lock password (no direct login)

    sudo chown -R actions:actions /opt/actions-runner


Follow the instructions in the github UI

## Install as a service

    sudo ./svc.sh install

    sudo ./svc.sh start


### If you get an errror

    svr01 runsvc.sh[44586]:    at System.IO.FileStream..ctor(String path, FileMode mode, FileAccess access, FileShare share, Int32 bufferSize)


    sudo systemctl edit actions.runner.*
verify:

    User=actions

    sudo systemctl daemon-reload

    sudo systemctl restart actions.runner.stocks-analyser.svr01.service


    systemctl status actions.runner.stocks-analyser.svr01.service

### Install docker

https://docs.docker.com/engine/install/ubuntu/