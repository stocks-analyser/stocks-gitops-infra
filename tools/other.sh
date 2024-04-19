#Generate an ssh-key (passwordless) and added as trusted in your repo
ssh-keygen -t ed25519 -a 100

# Main installation
kubectl apply -k environments/development




#openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem
# openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem -subj "/C=FR/ST=Occitanie/L=Toulouse/O=Tech School/OU=Education/CN=*.techschool.guru/emailAddress=techschool.guru@gmail.com"
#kubectl create -n argocd secret tls argocd-server-tls --cert=argocd-server-tls.pem --key=argocd-server-tls-key.pem -o yaml --dry-run=client > secret-tls-argocd-server-tls.yaml
#./create_sealed_secret.sh secret-tls-argocd-server-tls.yaml
#kubectl create -n argocd secret tls argocd-repo-server-tls --cert=argocd-server-tls.pem --key=argocd-server-tls-key.pem -o yaml --dry-run=client > argocd-repo-server-tls.yaml
#./create_sealed_secret.sh argocd-repo-server-tls.yaml
#kubectl apply -f sealed-private-repo-creds.yaml
