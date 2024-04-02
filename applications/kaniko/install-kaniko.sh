# echo "/opt/repos/stock-cluster/applications/kaniko/docker -alldirs -mapall="$(id -u)":"$(id -g)" $(minikube ip -p minik-nodes)" | sudo tee -a /etc/exports
# minikube stop -p minik-nodes
# minikube ssh -p minik-nodes
#minikube start --driver qemu --network socket_vmnet -p minik-nodes mount "/opt/repos/stock-cluster/applications/kaniko/docker:/data/dockerfiles"
minikube start --driver qemu --network socket_vmnet -p minik-nodes

#minikube addons enable storage-provisioner-rancher -p minik-nodes

cd /opt/repos/stock-cluster/applications/kaniko/

kubectl apply -f ns-kaniko.yaml
kubectl apply -f pv-dockerfile.yaml
kubectl apply -f pvc-dockerfile.yaml
kubectl apply -f pod-kaniko.yaml

minikube ssh -p minik-nodes
# kd exec -it -n kaniko kaniko -- bash


# UNINSTALL
kd delete ns kaniko  
kd delete pv dockerfile 