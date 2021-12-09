#!/bin/bash

# Set default shell to zsh
# chsh -s $(`which zsh`) $USER

# Using Tmux as default when start bash
#[[ "$TMUX" = "" ]] && tmux

alias root='sudo -i'
alias sophal='su - sophal'
alias sb='source ~/.bashrc'
alias vi='vim'
alias ll='ls -alhF --color=auto'
alias q='exit'

alias chk_port_ltn='sudo lsof -i -P -n &> /dev/null | grep LISTEN || sudo ss -tulpn | grep LISTEN || sudo netstat -tulpn | grep LISTEN'
alias generate_ctags='source ~/.my-terminal/vim/gentags_cscope'

alias ssh_101='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 192.168.0.101' #pw: root
alias ssh_102='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 192.168.0.102' #pw: root
alias ssh_103='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 192.168.0.103' #pw: root
alias ssh_tos='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 192.168.0.105' #pw: root
alias ssh_cos='ssh -o TCPKeepAlive=yes -o ServerAliveInterval=360 192.168.11.127' #pw: root
