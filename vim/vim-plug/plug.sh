#!/bin/bash
if ! [ -x "$(command -v vim)" ]; then
    echo "Installing vim..." >&2
    sudo apt install -y vim;
fi

if ! [ -x "$(command -v git)" ]; then
    echo "Installing git..." >&2
    sudo apt install -y git;
fi

# Get vim-plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

read -d '' VAR << EOF
"==========Vim-plug=========
"call plug#begin('~/.vim/plugged')
"
"" Make sure you use single quotes
"
"" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
"Plug 'junegunn/vim-easy-align'
"
"" Any valid git URL is allowed
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'
"
"" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
"
"" On-demand loading
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"
"" Using a non-master branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
"
"" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

"" Execute do after plug
"Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"
"" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
"
"" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"
"" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'
"
"" Initialize plugin system
"call plug#end()
"
" Then reload .vimrc and :PlugInstall to install plugins.
"
"
" Origin : https://github.com/junegunn/vim-plug
"============End of Vim-plug=========
EOF
echo "$VAR"
echo "---------"
echo -e "${VAR}\n\n$(cat ~/.vimrc)" > ~/.vimrc
