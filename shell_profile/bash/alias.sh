#!/bin/bash

# Set default shell to zsh
# chsh -s $(`which zsh`) $USER

# Using Tmux as default when start bash
#[[ "$TMUX" = "" ]] && tmux

# Golang Bash completion
# go get -u github.com/posener/complete/gocomplete
# gocomplete -install
# gocomplete -uninstall

# Golang env
export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN
export CGO_ENABLED=0

alias root='sudo -s'
alias sophal='su - sophal'
alias sb='source ~/.bashrc'

# maven bash completion
alias maven_completion='source ~/.myEnv/bash-completion/maven_completion.bash'
# VirtualBox bash completion
alias vb_completion='source ~/.myEnv/bash-completion/VBoxManage.bash'
# Velero bash completion
alias velero_completion='source <(velero completion bash)'
# goto bash completion
alias goto_completion='source ~/.myEnv/goto/goto.bash'

alias generate_ctags='source ~/.myEnv/others/gentags_cscope'
alias q='exit'

# Bash auto completion
[[ -x "$(command -v minikube)" ]] && source <(minikube completion bash)
[[ -x "$(command -v kubectl)" ]] && source <(kubectl completion bash)


alias ssh_101='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.101' #pw: root
alias ssh_102='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.102' #pw: root
alias ssh_103='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.103' #pw: root
alias ssh_tos='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.105' #pw: root

alias ssh_ck-ftp='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 ck-ftp@192.168.1.150' #pw: ck-ftp
alias ssh_tmax-cloud-ssh='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@175.195.163.11' #pw: tmax@cloud
alias ssh_ftp-clouduser-ssh='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 clouduser@192.168.2.175' #pw: tmaxcloud
alias ssh_pdc_compute='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@222.122.51.194' #pw: tmax@23
alias ssh_pdc_master='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@222.122.50.2' #pw: tmax@23
alias ssh_QA='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@172.22.7.2' #pw: tmax@23

# Kubernetes nodes
alias ssh_k8s_master='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 k8s@192.168.0.90' #pw: root
alias ssh_k8s_node-1='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 k8s@192.168.0.91' #pw: root
alias ssh_k8s_node-2='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 k8s@192.168.0.92' #pw: root
alias ssh_k8s_node-3='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 k8s@192.168.0.93' #pw: root
alias ssh_k8s_node-4='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 k8s@192.168.0.94' #pw: root


# Docker
# docker build -t [DOCKER_ACC]/[DOCKER_REPO]:[IMG_TAG] .
# docker build -t gildong/hyperstorage:test1 .

# imp_coldbrew_176
alias 176_scp_jar='scp ~/git/imp_coldbrew/target/TmaxCloudPO-0.0.1-SNAPSHOT-svc.jar root@172.22.10.6:/root/proobject7/ProZone/application/servicegroup/master/prozone-svc.jar'
alias 176_scp_xml='scp ~/git/imp_coldbrew/src/config/application/servicegroup/master/servicegroup.xml root@172.22.10.6:/root/proobject7/ProZone/application/servicegroup/master/config/'
alias 176_prozone_run='ssh root@172.22.10.6 bash /root/cmd/prozone_run.sh'
alias 176_prozone_down='ssh root@172.22.10.6 bash /root/cmd/prozone_down.sh'
alias 176_prozone_restart='176_prozone_down && 176_prozone_run'

# HyperCloud
alias ssh_docker-registry='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.56.50' #pw: root
alias ssh_hpc1='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.56.51' #pw: root
alias ssh_hpc2='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.56.52' #pw: root
alias ssh_hpc3='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.56.53' #pw: root
alias ssh_hpc4='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.56.54' #pw: root
alias ssh_hpc5='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.56.55' #pw: root

alias ssh_151='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.151' #pw: root
alias ssh_152='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.152' #pw: root
alias ssh_153='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.153' #pw: root
alias ssh_154='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.154' #pw: root
alias ssh_155='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 root@192.168.0.155' #pw: root

#export PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\] $(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] $\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
