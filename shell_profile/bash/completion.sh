#!/bin/bash

[[ -x "$(command -v minikube)" ]] && source <(minikube completion bash)
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion bash)
[[ -x "$(command -v velero)" ]] && source <(velero completion bash)
