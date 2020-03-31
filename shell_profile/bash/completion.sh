#!/bin/bash

[[ -x "$(command -v golangci-lint)" ]] && source <(golangci-lint completion bash)
[[ -x "$(command -v minikube)" ]] && source <(minikube completion bash)
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion bash)
[[ -x "$(command -v velero)" ]] && source <(velero completion bash)
[[ -x "$(command -v helm)" ]] && source <(helm completion bash)

[[ -x "$(command -v kctx)" ]] && source $MY_BASH_DIR/completions/kubectx.bash
[[ -x "$(command -v kns)" ]] && source $MY_BASH_DIR/completions/kubens.bash
