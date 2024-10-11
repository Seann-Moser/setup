alias nv="nvim"

# Filepath
alias cdp='cd ~/projects/github.com/'
alias cds='cd ~/go/src/github.com/Seann-Moser'
alias cdh='cd ~/go/src/github.com/HiroCloud'
alias cdhf='cd ~/go/src/github.com/HiroCloud/k8s-flux'
alias cdps='cd ~/go/src/github.com/Stodge-Inc/'

alias runAccess='chmod 777'

# ZSH
alias refresh="source ~/.zshrc"

alias kubectl-cleanup-pods='kubectl get pods --all-namespaces | grep -E "Evicted|ContainerStatusUnknown" | awk "{print \$1 \" \" \$2}" | xargs -n2 sh -c "kubectl delete pod \$1 -n \$0"'
# Docker
alias dcud='docker compose up -d'
alias dcub='docker compose up --build'

alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade && brew update && brew upgrade && flatpak update'
