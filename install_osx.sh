#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
case "$(uname -s)" in
	Linux*)
		OS=Linux
		APT=$(command -v apt)
		YUM=$(command -v yum)
		INSTALLER="sudo ${YUM:-$APT} -y"
		SED=$(command -v sed)
		BASHRC=${HOME}/.bashrc
		test -f ${BASHRC} || touch ${BASHRC}
		;;
	Darwin*)
		OS=Mac
		command -v brew &> /dev/null || { 
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
			echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile &&
			eval "$(/opt/homebrew/bin/brew shellenv)"
		}
		command -v gsed &> /dev/null || brew install gnu-sed
		command -v git &> /dev/null || brew install git
		command -v curl &> /dev/null || brew install curl
		INSTALLER=$(command -v brew)
		SED=$(command -v gsed)
		BASHRC=${HOME}/.bash_profile
		test -f ${BASHRC} || touch ${BASHRC}
		;;
	*)
		echo "UNKNOWN OS `uname -s`"
		exit 1
		;;
esac

CUR_SHELL="$(echo $SHELL|gsed 's:.*/::')"
INPUTRC=${DIR}/shell_profile/inputrc
TMUX_DIR=${DIR}/tmux
VIM_DIR=${DIR}/vim
VIMRC=${HOME}/.vimrc

function my-profile() {
	case "$CUR_SHELL" in
		bash)
			MYBASHRC=${DIR}/shell_profile/bashrc
			test -f ${MYBASHRC} || { echo "[ERROR] '${MYBASHRC}' NOT found!"; exit 1; }
			grep -q "^source ${MYBASHRC}" ${BASHRC} && \
				echo "[INFO] '${MYBASHRC}' is already added to '${BASHRC}'" || \
				echo "source ${MYBASHRC}" >> ${BASHRC};
			;;
		zsh)
			echo "Installing zsh-users/antigen ..."
			THEME=${DIR}/shell_profile/sophal.zsh-theme
			test -f ${THEME} || {
				echo "'${THEME}' NOT FOUNT!"
				exit 1
			}
			ZSHRC=${HOME}/.zshrc
			test -f ${ZSHRC} && mv ${ZSHRC} $HOME/.zshrc_`date +%Y%m%d_%H%M`
			touch ${ZSHRC}
			ANTIGEN=${HOME}/.antigen.zsh
			curl -L git.io/antigen > ${ANTIGEN}

			cat >> ${ZSHRC} <<-EOF
			source ${ANTIGEN}
			
			# Load the oh-my-zsh's library.
			antigen use oh-my-zsh
			
			# Bundles from the default repo (robbyrussell's oh-my-zsh).
			antigen bundle git
			antigen bundle heroku
			antigen bundle pip
			antigen bundle lein
			antigen bundle command-not-found
			
			# Syntax highlighting bundle.
			antigen bundle zsh-users/zsh-syntax-highlighting
			
			# Load the theme.
			antigen theme robbyrussell
			
			# Tell Antigen that you're done.
			antigen apply
			EOF
			echo "Done..."
			;;
		*)
			echo "UNSUPPORT SHELL ${CUR_SHELL}"
			exit 1
			;;
	esac

	ln -v -s ${INPUTRC} $HOME/.inputrc
	echo "[INFO] Execute 'source $HOME/.zshrc' or Open new Terminal"
}

function clean-my-profile() {
	${SED} -i "s|source ${MYBASHRC}||g" ${BASHRC}
	echo "[INFO] Removed my-profile bashrc..."
	sh -c "${ZSH_UNINS}"
	echo "[INFO] Removed Oh My Zsh..."
}


function my-tmux() {
	command -v tmux &> /dev/null || ${INSTALLER} install tmux
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
	command -v vim &> /dev/null || ${INSTALLER} install vim
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
	command -v curl &> /dev/null || ${INSTALLER} install curl
	test -f ${VIMRC} || my-vimrc
	PLUG_VIM=${HOME}/.vim/autoload/plug.vim
	test -f ${PLUG_VIM} || curl -fLo ${PLUG_VIM} --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	grep -q '^call plug#begin' ${VIMRC} || \
		${SED} -i "1icall plug#begin('~/.vim/plugged')\ncall plug#end()\n" ${VIMRC}
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
		${SED} -i "${LINE} a Plug '${1}'" ${VIMRC};
		vim +slient +VimEnter +PlugInstall +qall;
		echo "[INFO] vim plugin '${1}' is successfully installed!";
	fi
}

function install_vim-lazylist(){
	NAME="KabbAmine/lazyList.vim"
	MAPPING="Mapping gll to :LazyList<CR>"
	vim-install-plugin ${NAME}
	if ! grep -q "${MAPPING}" ${VIMRC}; then
		echo "[INFO] ${MAPPING}";
		cat >> ${VIMRC} <<-EOF

		"${MAPPING}
		autocmd VimEnter * if exists(":LazyList") | exe "nnoremap gll :LazyList<CR>" | endif
		autocmd VimEnter * if exists(":LazyList") | exe "vnoremap gll :LazyList<CR>" | endif
		EOF
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
		${INSTALLER} install exuberant-ctags || \
		${INSTALLER} install ctags
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
		${INSTALLER} install fonts-powerline &> /dev/null || \
		${INSTALLER} install powerline-fonts &> /dev/null || \
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
	install_vim-lazylist
	install_vim-nerdtree
	install_vim-tagbar
	install_vim-indent
	install_vim-airline
	install_vim-fugitive
	install_vim-surround
	install_vim-editorconfig
	install_vim-markdown
}

function user-password-less() {
	[ -z "$1" ] && echo "please input user to grant root permission" &&
		echo "[Usage]: $0 <USER>" && exit 1

	LOC=/etc/sudoers.d/$1
	[ -f $LOC ] && echo "'$1' is already exist in '$LOC'" && exit 1 ||
		echo "$1 ALL=(ALL) NOPASSWD:ALL" | sudo tee -a $LOC &&
		sudo chmod 0440 $LOC &&
		echo "[Done] set '$1' as root privilege without password..."
}

case "${1:-}" in
passwd-less)
	user-password-less $USER
	;;
profile)
	my-profile
	;;
tmux)
	my-tmux
	;;
vimrc)
	my-vimrc
	;;
vim-lazylist)
	install_vim-lazylist
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
clean-profile)
	clean-my-profile
	;;
clean-tmux)
	clean-my-tmux
	;;
clean-vimrc)
	clean-my-vimr
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
  passwd-less           Enable current user ($USER) to grant sudo permission without password
  profile               Setup and Configure my profile
  tmux                  Setup and configure tmux
  vimrc                 Setup and configure vim, vimrc
  vim-plugins           Install all default basic vim-plugins
  vim-lazylist          Install 'lazylist' vim-plug
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
