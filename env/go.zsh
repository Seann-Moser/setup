alias golinux="GOOS=linux GOARCH=amd64 go"

alias goR="go mod tidy && go mod vendor"
alias goU="go get -u && go mod tidy && go mod vendor"
alias goL="~/.local/share/JetBrains/Toolbox/apps/goland/bin/goland.sh ./"


export GOPATH=$HOME/go
#export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

export GONOPROXY="github.com/Kochava,git.dev.kochava.com,github.com/Seann-Moser,github.com/HiroCloud"
export GOPROXY="https://proxy.golang.org,direct"
export GONOSUMDB="github.com/Kochava,git.dev.kochava.com,github.com/Seann-Moser,github.com/HiroCloud"
export GOPRIVATE="github.com/Kochava,git.dev.kochava.com,github.com/Seann-Moser,github.com/HiroCloud"


export PATH="$PATH:$HOME/.cargo/bin"

