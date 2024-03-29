# configure .zshrc the following way to allow auto-completion
# autoload -Uz compinit
# compinit
# alias k=kubectl
# source <(kubectl completion zsh)
# compdef k='kubectl'

brew install kubectl

# Kubectl autocompletionzsh
echo '[[ $commands[kubectl] ]] && source <(kubectl completion zsh)' >> ~/.zshrc # add autocomplete permanently to your zsh shell
