colima start --vm-type vz --cpu 4 --memory 4
minikube start --driver=docker --nodes=2 -p minik-nodes --extra-config=kubelet.housekeeping-interval=10s
