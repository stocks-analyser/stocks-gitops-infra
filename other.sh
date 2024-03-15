# Run main installation
kubectl apply -k argocd

#Check if the argocd namespace has already been created

#Create the sealed-secret with the credentials to create to Argo
# Access to the repo
./create_sealed_secret.sh argocd-repo-creds.unsealed.yaml
mv argocd-repo-creds.unsealed.yaml sealed-argocd-repo-creds.yaml
kubectl apply -f sealed-argocd-repo-creds.yaml

kubectl apply -k environments/development


#openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem
# openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem -subj "/C=FR/ST=Occitanie/L=Toulouse/O=Tech School/OU=Education/CN=*.techschool.guru/emailAddress=techschool.guru@gmail.com"
#kubectl create -n argocd secret tls argocd-server-tls --cert=argocd-server-tls.pem --key=argocd-server-tls-key.pem -o yaml --dry-run=client > secret-tls-argocd-server-tls.yaml
#./create_sealed_secret.sh secret-tls-argocd-server-tls.yaml
#kubectl create -n argocd secret tls argocd-repo-server-tls --cert=argocd-server-tls.pem --key=argocd-server-tls-key.pem -o yaml --dry-run=client > argocd-repo-server-tls.yaml
#./create_sealed_secret.sh argocd-repo-server-tls.yaml
