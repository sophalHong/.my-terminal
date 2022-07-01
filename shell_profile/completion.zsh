[[ -x "$(command -v kc)" ]] && source <(kc completion zsh | sed -e 's/kubectl/kc/g')
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion zsh)
[[ -x "$(command -v golangci-lint)" ]] && source <(golangci-lint completion zsh)
[[ -x "$(command -v operator-sdk)" ]] && source <(operator-sdk completion zsh)
[[ -x "$(command -v kubebuilder)" ]] && source <(kubebuilder completion zsh)
[[ -x "$(command -v kustomize)" ]] && source <(kustomize completion zsh)
[[ -x "$(command -v minikube)" ]] && source <(minikube completion zsh)
[[ -x "$(command -v kind)" ]] && source <(kind completion zsh)
[[ -x "$(command -v k3d)" ]] && source <(k3d completion zsh)
[[ -x "$(command -v velero)" ]] && source <(velero completion zsh)
[[ -x "$(command -v argo)" ]] && source <(argo completion zsh)
[[ -x "$(command -v helm)" ]] && source <(helm completion zsh)

#[[ -x "$(command -v kctx)" ]] && source $MY_BASH_DIR/completions/kubectx.bash
#[[ -x "$(command -v kns)" ]] && source $MY_BASH_DIR/completions/kubens.bash
#[[ -x "$(command -v VBoxManage)" ]] && source $MY_BASH_DIR/completions/VBoxManage.bash
#[[ -x "$(command -v goto)" ]] && source $MY_BASH_DIR/completions/goto.bash
#[[ -x "$(command -v mvn)" ]] && source $MY_BASH_DIR/completions/maven.bash
#[[ -x "$(command -v docker-compose)" ]] && source $MY_BASH_DIR/completions/docker-compose.bash
#[[ -x "$(command -v aws_completer)" ]] && complete -C `which aws_completer` aws
#[[ -x "$(command -v terraform)" ]] && complete -C `which terraform` terraform
#[[ -x "$(command -v packer)" ]] && complete -C `which packer` packer
