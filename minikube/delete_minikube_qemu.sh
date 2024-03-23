minikube stop -p minik-nodes
minikube delete -p minik-nodes

# Uninstall colima
colima stop --force
colima delete default

brew uninstall qemu
brew uninstall minkubes
