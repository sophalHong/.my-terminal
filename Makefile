# Bash is required as the shell
SHELL := /usr/bin/env bash

# Set Makefile directory in variable for referencing other files
MFILECWD = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
BASHRC ?= $(MFILECWD)shell_profile/bash/mybashrc
ZSHRC ?= $(MFILECWD)shell_profile/zsh/mybashrc
TMUX_DIR ?= $(MFILECWD)tmux
VIM_DIR ?= $(MFILECWD)vim
VIMRC ?= $(HOME)/.vimrc

APT ?= $(shell command -v apt)
YUM ?= $(shell command -v yum)

INSTALLER := $(if $(APT),$(APT),$(YUM))

profile: ## Configure my profile
ifeq (,$(wildcard $(BASHRC)))
	$(error `$(BASHRC)` NOT FOUND)
endif
ifneq (,$(wildcard $(HOME)/.bashrc))
	@grep -q $(BASHRC) $(HOME)/.bashrc && \
		echo "'$(BASHRC)' is already added to '$(HOME)/.bashrc'" || \
		echo "source $(BASHRC)" >> $(HOME)/.bashrc;
	$(info Execute: 'source $(HOME)/.bashrc' to activate my profile)
else
	$(error `$(HOME)/.bashrc` file does NOT exist)
endif

tmux: ## Setup and configure tmux
	@command -v tmux &> /dev/null || sudo $(INSTALLER) install -y tmux
ifneq (,$(wildcard $(HOME)/.tmux.conf))
	@mv $(HOME)/.tmux.conf $(HOME)/.tmux.conf_bak`date +%Y%m%d_%H%M`
endif
ifneq (,$(wildcard $(HOME)/.tmux.conf.local))
	@mv $(HOME)/.tmux.conf.local $(HOME)/.tmux.conf.local_bak`date +%Y%m%d_%H%M`
endif
	@cp -v $(TMUX_DIR)/tmux.conf $(HOME)/.tmux.conf
	@cp -v $(TMUX_DIR)/tmux.conf.local $(HOME)/.tmux.conf.local

vimrc: ## Setup and configure vim
	@command -v vim &> /dev/null || sudo $(INSTALLER) install -y vim
ifneq (,$(wildcard $(HOME)/.vim/.*))
	@mv $(HOME)/.vim $(HOME)/.vim_bak`date +%Y%m%d_%H%M`
endif
ifneq (,$(wildcard $(HOME)/.vimrc))
	@mv $(HOME)/.vimrc $(HOME)/.vimrc_bak`date +%Y%m%d_%H%M`
endif
	@mkdir -p $(HOME)/.vim
	@cp -v $(VIM_DIR)/vimrc_basic $(VIMRC)

vim-plug: ## Get and install vim-plug
	@command -v curl &> /dev/null || sudo $(INSTALLER) install -y curl
	$(eval PLUG-VIM := $(HOME)/.vim/autoload/plug.vim)
	@test -f $(PLUG-VIM) || curl -fLo $(PLUG-VIM) --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	@command -v sed &> /dev/null || sudo $(INSTALLER) install -y sed
	@grep -q '^call plug#begin' $(VIMRC) || \
		sed -i "1icall plug#begin('~/.vim/plugged')\ncall plug#end()\n" $(VIMRC)

vim-install-plugin: vim-plug ## Add nerdtree vim-plug
ifndef PLUGIN
	$(error Pluging 'PLUGIN=<name>' is NOT provided!)
endif
	@grep -q '^call plug#begin' $(VIMRC) || $(MAKE) vim-plug;
	$(eval LINE := $(shell awk '/^call plug#begin/{print NR; exit}' $(VIMRC)))
	@if [ "$(LINE)" == "" ]; then \
		echo "[ERROR] Cannot get find call plug\#being() function in '$(VIMRC)'"; \
		exit 1; \
	fi
	@if grep -q "^Plug '$(PLUGIN)'" $(VIMRC); then \
		echo "[INFO] vim plugin '$(PLUGIN)' is already installed!"; \
	else \
		command -v sed &> /dev/null || sudo $(INSTALLER) install -y sed; \
		sed -i "$(LINE) a Plug '$(PLUGIN)'" $(VIMRC); \
		vim +slient +VimEnter +PlugInstall +qall; \
		echo "[INFO] vim plugin '$(PLUGIN)' is successfully installed!"; \
	fi

vim-nerdtree: ## Install 'nerdtree' vim-plug
	$(eval NAME := preservim/nerdtree)
	$(eval MAPPING := Mapping <Tab> to :NERDTreeToggle<CR>)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@if ! grep -q '$(MAPPING)' $(VIMRC); then \
		echo "[INFO] $(MAPPING)"; \
		echo -e '\n"$(MAPPING)' >> $(VIMRC); \
		echo 'autocmd VimEnter * if exists(":NERDTreeToggle") | exe "map <Tab> :NERDTreeToggle<CR>" | endif' >> $(VIMRC); \
	fi

vim-tagbar: ## Install 'tagbar' vim-plug
	@command -v ctags-exuberant &> /dev/null || sudo $(INSTALLER) install exuberant-ctags -y
	$(eval NAME := preservim/tagbar)
	$(eval MAPPING := Mapping <space> to :TagbarToggle<CR>)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@if ! grep -q '$(MAPPING)' $(VIMRC); then \
		echo "[INFO] $(MAPPING)"; \
		echo -e '\n"$(MAPPING)' >> $(VIMRC); \
		echo 'autocmd VimEnter * if exists(":TagbarToggle") | exe "nnoremap <Space> :TagbarToggle<CR>" | endif' >> $(VIMRC); \
	fi

vim-indent: ## Install 'Indent' vim-plug
	$(eval NAME := nathanaelkane/vim-indent-guides)
	$(eval MAPPING := Mapping Ctrl+n to :IndentGuidesToggle<CR>)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@if ! grep -q '$(MAPPING)' $(VIMRC); then \
		echo "[INFO] $(MAPPING)"; \
		echo -e '\n"$(MAPPING)' >> $(VIMRC); \
		echo 'autocmd VimEnter * if exists(":IndentGuidesToggle") | exe "map <c-n> :IndentGuidesToggle<CR>" | endif' >> $(VIMRC); \
		echo 'let g:indent_guides_enable_on_vim_startup = 0' >> $(VIMRC); \
		echo 'let g:indent_guides_guide_size = 1' >> $(VIMRC); \
		echo 'let g:indent_guides_auto_colors = 0' >> $(VIMRC); \
		echo 'autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=235' >> $(VIMRC); \
		echo 'autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237' >> $(VIMRC); \
	fi

vim-airline: ## Install 'Airline' and 'Airline-themes' vim-plug
	@sudo $(INSTALLER) install -y fonts-powerline &> /dev/null || \
		sudo $(INSTALLER) install -y powerline-fonts &> /dev/null || \
		{ git clone https://github.com/powerline/fonts.git --depth=1; \
		./fonts/install.sh; rm -rf fonts; }
	$(eval NAME := vim-airline/vim-airline)
	$(eval THEME := vim-airline/vim-airline-themes)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@PLUGIN=$(THEME) $(MAKE) vim-install-plugin --no-print-directory
	$(eval CONFIG := Setting default airline customized configuration)
	@if ! grep -q '$(CONFIG)' $(VIMRC); then \
		echo "[INFO] $(CONFIG)"; \
		echo -e '\n"$(CONFIG)' >> $(VIMRC); \
		echo "let g:airline#extensions#tabline#enabled = 1" >> $(VIMRC); \
		echo "let g:airline#extensions#tabline#left_sep = ' '" >> $(VIMRC); \
		echo "let g:airline#extensions#tabline#left_alt_sep = '|'" >> $(VIMRC); \
		echo "let g:airline_left_sep = ''" >> $(VIMRC); \
		echo "let g:airline_right_sep = ''" >> $(VIMRC); \
	fi

vim-markdown: ## Install 'markdown-preview.nvim' vim-plug
	$(eval NAME := iamcco/markdown-preview.nvim)
	$(eval MAPPING := Mapping Ctrl+m to <Plug>MarkdownPreviewToggle)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@if ! grep -q '$(MAPPING)' $(VIMRC); then \
		echo "[INFO] $(MAPPING)"; \
		echo -e '\n"$(MAPPING)' >> $(VIMRC); \
		echo 'nmap <C-m> <Plug>MarkdownPreviewToggle' >> $(VIMRC); \
	fi
	$(eval BIN := $(HOME)/.vim/plugged/markdown-preview.nvim/app/bin/markdown-preview-linux)
	@test -f $(BIN) || \
		{ cd $(HOME)/.vim/plugged/markdown-preview.nvim/app; \
		./install.sh; \
		echo [INFO] Markdown-preview-linux sucessfully installed!; }

vim-fugitive: ## Install 'vim-fugitive' vim-plug (Git plugin for Vim)
	$(eval NAME := tpope/vim-fugitive)
	$(eval MAPPING := Mapping Ctrl+g to :Gstatus<CR>)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@if ! grep -q '$(MAPPING)' $(VIMRC); then \
		echo "[INFO] $(MAPPING)"; \
		echo -e '\n"$(MAPPING)' >> $(VIMRC); \
		echo 'autocmd VimEnter * if exists(":Gstatus") | exe "map <c-g> :Gstatus<CR>" | endif' >> $(VIMRC); \
	fi

vim-editorconfig: ## Install 'editorconfig' vim-plug
	$(eval NAME := editorconfig/editorconfig-vim)
	$(eval SETTING := Setting defautl editor configuration)
	@PLUGIN=$(NAME) $(MAKE) vim-install-plugin --no-print-directory
	@if ! grep -q '$(SETTING)' $(VIMRC); then \
		echo "[INFO] $(SETTING)"; \
		echo -e '\n"$(SETTING)' >> $(VIMRC); \
		echo 'au FileType gitcommit let b:EditorConfig_disable = 1' >> $(VIMRC); \
		echo '"let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']' >> $(VIMRC); \
	fi

help: ## Show this help menu.
	@echo "Usage: make [TARGET ...]"
	@echo
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:
.PHONY: help profile tmux \
	vimrc vim-plug vim-install-plugin \
	vim-nerdtree vim-tagbar
