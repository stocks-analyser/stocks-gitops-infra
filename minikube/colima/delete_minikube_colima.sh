minikube stop -p minik-nodes
minikube delete -p minik-nodes

docker stop $( docker ps -qa )
docker rm $( docker ps -qa )
docker system prune
docker builder prune

# Uninstall colima
colima stop --force
colima delete
colima prune -a


brew remove colima lima qemu
unlink /opt/homebrew/var/homebrew/linked/colima
sudo rm -rf /opt/homebrew/Cellar/colima/0.6.8
brew autoremove
