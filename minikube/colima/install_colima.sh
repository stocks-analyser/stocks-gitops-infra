

# https://mvmn.wordpress.com/2023/10/26/switching-from-docker-desktop-to-colima-on-macos/

brew install colima

#sudo brew services start colima #if needed run this at start
brew install docker docker-compose

mkdir -p ~/.docker/cli-plugins
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose


colima start --vm-type vz --cpu 4 --memory 4


#https://everythingdevops.dev/how-to-run-minikube-on-apple-m1-chip-without-docker-desktop/
brew install minikube
minikube start --driver=docker --nodes=2 -p minik-nodes --extra-config=kubelet.housekeeping-interval=10s
