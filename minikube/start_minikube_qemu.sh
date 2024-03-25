#HOMEBREW=$(which brew) && sudo ${HOMEBREW} services start socket_vmnet
#brew services restart socket_vmnet
#minikube start --driver qemu --network socket_vmnet --nodes=2 -p minik-nodes --memory='4g' --cpus='2'
minikube start --driver qemu --network socket_vmnet -p minik-nodes --memory='4g' --cpus='2'
