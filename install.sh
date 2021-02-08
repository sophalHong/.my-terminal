#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
BASHRC=${DIR}/shell_profile/`echo $SHELL|sed 's:.*/::'`/mybashrc
TMUX_DIR=${DIR}/tmux
VIM_DIR=${DIR}/vim
VIMRC=${HOME}/.vimrc
APT=$(command -v apt)
YUM=$(command -v yum)
INSTALLER=${YUM:-$APT}

function my-profile() {
	test -f ${BASHRC} || { echo "[ERROR] '${BASHRC}' NOT found!"; exit 1; }
	grep -q "^source ${BASHRC}" ${HOME}/.bashrc && \
		echo "[INFO] '${BASHRC}' is already added to '${HOME}/.bashrc'" || \
		echo "source ${BASHRC}" >> ${HOME}/.bashrc;
}

function clean-my-profile() {
	sed -i "s|source ${BASHRC}||g" ${HOME}/.bashrc
	echo "[INFO] Romoved my-profile bashrc..."
}


function my-tmux() {
	command -v tmux &> /dev/null || sudo ${INSTALLER} install -y tmux
	test -f ${HOME}/.tmux.conf && \
		mv ${HOME}/.tmux.conf ${HOME}/.tmux.conf_ori_`date +%Y%m%d_%H%M`
	test -f ${HOME}/.tmux.conf.local && \
		mv ${HOME}/.tmux.conf.local ${HOME}/.tmux.conf.local_ori_`date +%Y%m%d_%H%M`
	cp ${TMUX_DIR}/tmux.conf ${HOME}/.tmux.conf
	cp ${TMUX_DIR}/tmux.conf.local ${HOME}/.tmux.conf.local
}

function clean-my-tmux() {
	test -f ${HOME}/.tmux.conf && \
		mv -v ${HOME}/.tmux.conf ${HOME}/.tmux.conf_ori_`date +%Y%m%d_%H%M`
	test -f ${HOME}/.tmux.conf.local && \
		mv -v ${HOME}/.tmux.conf.local ${HOME}/.tmux.conf.local_ori_`date +%Y%m%d_%H%M`
	echo "[INFO] Romoved tmux configuration..."
}

function my-vimrc() {
	command -v vim &> /dev/null || sudo ${INSTALLER} install -y vim
	[ -d ${HOME}/.vim ] && \
		mv ${HOME}/.vim ${HOME}/.vim_ori_`date +%Y%m%d_%H%M`
	[ -f ${HOME}/.vimrc ] && \
		mv ${HOME}/.vimrc ${HOME}/.vimrc_ori_`date +%Y%m%d_%H%M`
	mkdir -p ${HOME}/.vim
	cp ${VIM_DIR}/vimrc_basic ${VIMRC}
}

function clean-my-vimrc() {
	[ -d ${HOME}/.vim ] && \
		mv -v ${HOME}/.vim ${HOME}/.vim_ori_`date +%Y%m%d_%H%M`
	[ -f ${HOME}/.vimrc ] && \
		mv -v ${HOME}/.vimrc ${HOME}/.vimrc_ori_`date +%Y%m%d_%H%M`
	echo "[INFO] Romoved vimrc configuration..."
}

function vim-plug() {
	command -v curl &> /dev/null || sudo ${INSTALLER} install -y curl
	test -f ${VIMRC} || my-vimrc
	PLUG_VIM=${HOME}/.vim/autoload/plug.vim
	test -f ${PLUG_VIM} || curl -fLo ${PLUG_VIM} --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	command -v sed &> /dev/null || sudo ${INSTALLER} install -y sed
	grep -q '^call plug#begin' ${VIMRC} || \
		sed -i "1icall plug#begin('~/.vim/plugged')\ncall plug#end()\n" ${VIMRC}
}

function vim-install-plugin() {
	[ -z $1 ] && { echo "[ERROR] vim plugins NAME is NOT provided!"; exit 1; }
	vim-plug
	LINE=$(awk '/^call plug#begin/{print NR; exit}' ${VIMRC})
	if [ "${LINE}" == "" ]; then
		echo "[ERROR] Cannot get find call plug\#being() function in '${VIMRC}'";
		exit 1;
	fi
	if grep -q "^Plug '${1}'" ${VIMRC}; then
		echo "[INFO] vim plugin '${1}' is already installed!";
	else
		command -v sed &> /dev/null || sudo ${INSTALLER} install -y sed;
		sed -i "${LINE} a Plug '${1}'" ${VIMRC};
		vim +slient +VimEnter +PlugInstall +qall;
		echo "[INFO] vim plugin '${1}' is successfully installed!";
	fi
}

function install_vim-nerdtree(){
	NAME="preservim/nerdtree"
	MAPPING="Mapping <Tab> to :NERDTreeToggle<CR>"
	vim-install-plugin ${NAME}
	if ! grep -q "${MAPPING}" ${VIMRC}; then
		echo "[INFO] ${MAPPING}";
		cat >> ${VIMRC} <<-EOF

		"${MAPPING}
		autocmd VimEnter * if exists(":NERDTreeToggle") | exe "map <Tab> :NERDTreeToggle<CR>" | endif
		EOF
	fi
}

function install_vim-tagbar(){
	command -v ctags &> /dev/null || \
		sudo ${INSTALLER} install -y exuberant-ctags || \
		sudo ${INSTALLER} install -y ctags
	NAME="preservim/tagbar"
	MAPPING="Mapping <space> to :TagbarToggle<CR>"
	vim-install-plugin ${NAME}
	if ! grep -q "${MAPPING}" ${VIMRC}; then
		echo "[INFO] ${MAPPING}";
		cat >> ${VIMRC} <<-EOF

		"${MAPPING}
		autocmd VimEnter * if exists(":TagbarToggle") | exe "nnoremap <Space> :TagbarToggle<CR>" | endif
		EOF
	fi
}

function install_vim-indent(){
	NAME="nathanaelkane/vim-indent-guides"
	MAPPING="Mapping Ctrl+n to :IndentGuidesToggle<CR>"
	vim-install-plugin ${NAME}
	if ! grep -q "${MAPPING}" ${VIMRC}; then
		echo "[INFO] ${MAPPING}";
		cat >> ${VIMRC} <<-EOF

		"${MAPPING}
		autocmd VimEnter * if exists(":IndentGuidesToggle") | exe "map <c-n> :IndentGuidesToggle<CR>" | endif
		let g:indent_guides_enable_on_vim_startup = 0
		let g:indent_guides_guide_size = 1
		let g:indent_guides_auto_colors = 0
		autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=235
		autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237
		EOF
	fi
}

function install_vim-airline(){
	test -f /etc/fonts/conf.d/10-powerline-symbols.conf || \
		sudo ${INSTALLER} install -y fonts-powerline || \
		sudo ${INSTALLER} install -y powerline-fonts || \
		{ git clone https://github.com/powerline/fonts.git --depth=1; \
		./fonts/install.sh; rm -rf fonts; }
	NAME="vim-airline/vim-airline"
	THEME="vim-airline/vim-airline-themes"
	vim-install-plugin ${NAME}
	vim-install-plugin ${THEME}
	SETTING="Setting default airline customized configuration"
	if ! grep -q "${SETTING}" ${VIMRC}; then
		echo "[INFO] ${SETTING}";
		cat >> ${VIMRC} <<-EOF

		"${CONFIG}
		let g:airline#extensions#tabline#enabled = 1
		let g:airline#extensions#tabline#left_sep = ' '
		let g:airline#extensions#tabline#left_alt_sep = '|'
		let g:airline_left_sep = ''
		let g:airline_right_sep = ''
		EOF
	fi
}

function install_vim-fugitive(){
	NAME="tpope/vim-fugitive"
	MAPPING="Mapping Ctrl+g to :Gstatus<CR>"
	vim-install-plugin ${NAME}
	if ! grep -q "${MAPPING}" ${VIMRC}; then
		echo "[INFO] ${MAPPING}";
		cat >> ${VIMRC} <<-EOF

		"${MAPPING}
		autocmd VimEnter * if exists(":Gstatus") | exe "map <c-g> :Gstatus<CR>" | endif
		EOF
	fi
}

function install_vim-surround(){
	NAME="tpope/vim-surround"
	SETTING="Setting defautl surround configuration"
	vim-install-plugin ${NAME}
	if ! grep -q "${SETTING}" ${VIMRC}; then
		echo "[INFO] ${SETTING}";
		cat >> ${VIMRC} <<-EOF

		"${SETTING}
		"Press cs"' To change "hello" to 'hello'
		"Press cst" To go full circle
		"Press ds" To remove the delimiters entirely
		"Now with cursor on "Hello", press yssiw] To change to [Hello] world!
		"Wrap the entire line with yssb or yss)
		EOF
	fi
}

function install_vim-editorconfig(){
	NAME="editorconfig/editorconfig-vim"
	SETTING="Setting defautl editor configuration"
	vim-install-plugin ${NAME}
	if ! grep -q "${SETTING}" ${VIMRC}; then
		echo "[INFO] ${SETTING}";
		cat >> ${VIMRC} <<-EOF

		"${SETTING}
		au FileType gitcommit let b:EditorConfig_disable = 1
		"let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
		EOF
	fi
}

function install_vim-markdown(){
	NAME="iamcco/markdown-preview.nvim"
	MAPPING="Mapping Ctrl+m to <Plug>MarkdownPreviewToggle"
	vim-install-plugin ${NAME}
	if ! grep -q "${MAPPING}" ${VIMRC}; then
		echo "[INFO] ${MAPPING}";
		cat >> ${VIMRC} <<-EOF

		"${MAPPING}
		nmap <C-m> <Plug>MarkdownPreviewToggle
		EOF
	fi
	BIN=${HOME}/.vim/plugged/markdown-preview.nvim/app/bin/markdown-preview-linux
	test -f ${BIN} || \
		{ cd ${HOME}/.vim/plugged/markdown-preview.nvim/app; \
		./install.sh; \
		echo [INFO] Markdown-preview-linux sucessfully installed!; }
}

function my-vim_plugins() {
	my-vimrc
	install_vim-nerdtree
	install_vim-tagbar
	install_vim-indent
	install_vim-airline
	install_vim-fugitive
	install_vim-surround
	install_vim-editorconfig
	install_vim-markdown
}

case "${1:-}" in
profile)
	my-profile
	;;
tmux)
	my-tmux
	;;
vimrc)
	my-vimrc
	;;
vim-nerdtree)
	install_vim-nerdtree
	;;
vim-tagbar)
	install_vim-tagbar
	;;
vim-indent)
	install_vim-indent
	;;
vim-airline)
	install_vim-airline
	;;
vim-fugitive)
	install_vim-fugitive
	;;
vim-surround)
	install_vim-surround
	;;
vim-editorconfig)
	install_vim-editorconfig
	;;
vim-markdown)
	install_vim-markdown
	;;
vim-plugins)
	my-vim_plugins
	;;
all)
	my-profile
	my-tmux
	my-vim_plugins
	;;
clean)
	clean-my-profile
	clean-my-tmux
	clean-my-vimrc
	;;
help|*)
	echo "$0 [command]
Available Commands:
  help                  Show this help menu.
  all                   Install all default basic setting (bashrc,tmux,vim-plugins)
  profile               Configure my profile
  tmux                  Setup and configure tmux
  vimrc                 Setup and configure vim
  vim-nerdtree          Install 'nerdtree' vim-plug
  vim-tagbar            Install 'tagbar' vim-plug
  vim-indent            Install 'Indent' vim-plug
  vim-airline           Install 'Airline' and 'Airline-themes' vim-plug
  vim-fugitive          Install 'vim-fugitive' vim-plug (Git plugin for Vim)
  vim-surround          Install 'surround' vim-plug
  vim-editorconfig      Install 'editorconfig' vim-plug
  vim-markdown          Install 'markdown-preview.nvim' vim-plug
  clean                 Clean all settings (profile,tmux,vimrc)
" >&2
	;;
esac
