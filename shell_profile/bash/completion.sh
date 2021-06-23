#!/bin/bash

# Golang Bash completion
# go get -u github.com/posener/complete/gocomplete
# gocomplete -install
# gocomplete -uninstall

[[ -x "$(command -v golangci-lint)" ]] && source <(golangci-lint completion bash)
[[ -x "$(command -v minikube)" ]] && source <(minikube completion bash)
[[ -x "$(command -v kind)" ]] && source <(kind completion bash)
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion bash)
[[ -x "$(command -v kc)" ]] && source <(kc completion bash | sed -e 's/kubectl/kc/g')
[[ -x "$(command -v velero)" ]] && source <(velero completion bash)
[[ -x "$(command -v argo)" ]] && source <(argo completion bash)
[[ -x "$(command -v k3d)" ]] && source <(k3d completion bash)
[[ -x "$(command -v helm)" ]] && source <(helm completion bash)

[[ -x "$(command -v kctx)" ]] && source $MY_BASH_DIR/completions/kubectx.bash
[[ -x "$(command -v kns)" ]] && source $MY_BASH_DIR/completions/kubens.bash

[[ -x "$(command -v VBoxManage)" ]] && source $MY_BASH_DIR/completions/VBoxManage.bash
[[ -x "$(command -v goto)" ]] && source $MY_BASH_DIR/completions/goto.bash

[[ -x "$(command -v mvn)" ]] && source $MY_BASH_DIR/completions/maven.bash
