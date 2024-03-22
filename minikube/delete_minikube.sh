
# Uninstall colima
colima delete default
colima stop --force


brew uninstall colima
unlink /opt/homebrew/var/homebrew/linked/colima
sudo rm -rf /opt/homebrew/Cellar/colima/0.6.8


minikube delete -p minik-nodes


docker stop $( docker ps -qa )
docker rm $( docker ps -qa )
docker system prune
docker builder prune
