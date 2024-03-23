# .zshrc
# autoload -Uz compinit
# compinit
# alias k=kubectl
# source <(kubectl completion zsh)
# compdef k='kubectl'

echo 'export MINIKUBE_HOME=/Volumes/TOSHIBA01/projectskubernetes/.minikube' >> ~/.zprofile
source ~/.zprofile

#https://devopscube.com/minikube-mac/
brew install qemu
brew install socket_vmnet

brew tap homebrew/services
HOMEBREW=$(which brew) && sudo ${HOMEBREW} services start socket_vmnet

brew install minikube
#minikube start --driver qemu --network socket_vmnet
minikube start --driver qemu --network socket_vmnet --nodes=2 -p minik-nodes --memory='4g' --cpus='2'
