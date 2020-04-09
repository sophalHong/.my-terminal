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
export GOROOT=/usr/local/go
export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN

alias root='sudo -s'
alias sb='source ~/.bashrc'
alias vi='vim'

alias chk_port_ltn='sudo lsof -i -P -n | grep LISTEN'

# maven bash completion
alias maven_completion='source ~/.myEnv/bash-completion/maven_completion.bash'
alias generate_ctags='source ~/.myEnv/others/gentags_cscope'
alias q='exit'

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
alias ssh_gitlab-runner='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 gitlab-runner@172.22.4.105' #pw: tmax@34

# Docker
# docker build -t [DOCKER_ACC]/[DOCKER_REPO]:[IMG_TAG] .
# docker build -t gildong/hyperstorage:test1 .

# imp_coldbrew_176
alias 176_scp_jar='scp ~/git/imp_coldbrew/target/TmaxCloudPO-0.0.1-SNAPSHOT-svc.jar root@172.22.10.6:/root/proobject7/ProZone/application/servicegroup/master/prozone-svc.jar'
alias 176_scp_xml='scp ~/git/imp_coldbrew/src/config/application/servicegroup/master/servicegroup.xml root@172.22.10.6:/root/proobject7/ProZone/application/servicegroup/master/config/'
alias 176_prozone_run='ssh root@172.22.10.6 bash /root/cmd/prozone_run.sh'
alias 176_prozone_down='ssh root@172.22.10.6 bash /root/cmd/prozone_down.sh'
alias 176_prozone_restart='176_prozone_down && 176_prozone_run'

#export PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\] $(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] $\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
