# Bash is required as the shell
SHELL := /usr/bin/env bash

# Set Makefile directory in variable for referencing other files
MFILECWD = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
PROFILE_DIR ?= $(MFILECWD)shell_profile
TMUX_DIR ?= $(MFILECWD)tmux
VIM_DIR ?= $(MFILECWD)vim

APT ?= $(shell command -v apt)
YUM ?= $(shell command -v yum)

INSTALLER := $(if $(APT),$(APT),$(YUM))

profile: ## Configure my profile
	[ -d $(HOME)/.bashrc ] && \
		echo "source $(PROFILE_DIR)/bash/mybashrc" >> $(HOME)/.bashrc || \
		echo "'$(HOME)/.bashrc' NOT found"

tmux: ## Setup and configure tmux
	command -v tmux &> /dev/null || sudo $(INSTALLER) install -y tmux
	[ -f $(HOME)/.tmux.conf ] && \
		mv $(HOME)/.tmux.conf $(HOME)/.tmux.conf_bak`date +%y%m%d_%H%M`
	[ -f $(HOME)/.tmux.conf.local ] && \
		mv $(HOME)/.tmux.conf.local $(HOME)/.tmux.conf.local_bak`date +%y%m%d_%H%M`
	cp -v $(TMUX_DIR)/tmux.conf $(HOME).tmux.conf
	cp -v $(TMUX_DIR)/tmux.conf.local $(HOME).tmux.conf.local

vim: ## Setup and configure vim
	command -v vim &> /dev/null || sudo $(INSTALLER) install -y vim
	[ -d $(HOME)/.vim ] && \
		mv $(HOME)/.vim $(HOME)/.vim_bak`date +%y%m%d_%H%M`
	[ -f $(HOME)/.vimrc ] && \
		mv $(HOME)/.vimrc $(HOME)/.vimrc_bak`date +%y%m%d_%H%M`
	mkdir -p $(HOME)/.vim
	cp -v $(VIM_DIR)/vimrc $(HOME)/.vimrc


help: ## Show this help menu.
	@echo "Usage: make [TARGET ...]"
	@echo
	@grep -E '^[a-zA-Z_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
.EXPORT_ALL_VARIABLES:
.PHONY: tmux help
