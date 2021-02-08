# My Terminal
This repository is created to have my terminal setting on every new created linux system.
It includes configuration setting of **shell(bash/zsh) profile**, **tmux**, and **vim plugins**, which are my basic development environment tools.

## Quick install
```shell
make all
```

### Shell profile (bashrc)
```shell
make profile
```
![profile](./images/shell_profile.png)

### tmux
```shell
make tmux
```
![tmux](./images/tmux.png)

### vim plugins
```shell
make vim-plugins
```
![vim](./images/vim-plugins.png)

### More targets
```shell
Usage: make [TARGET ...]

help                           Show this help menu.
all                            Install all default basic setting (bashrc,tmux,vim-plugins)
profile                        Configure my profile
tmux                           Setup and configure tmux
vimrc                          Setup and configure vim
vim-plugins                    Install default basic vim plugins
vim-airline                    Install 'Airline' and 'Airline-themes' vim-plug
vim-editorconfig               Install 'editorconfig' vim-plug
vim-fugitive                   Install 'vim-fugitive' vim-plug (Git plugin for Vim)
vim-indent                     Install 'Indent' vim-plug
vim-install-plugin             Install specific Vim plugin (PLUGIN=<username>/<plugin> required)
vim-markdown                   Install 'markdown-preview.nvim' vim-plug
vim-nerdtree                   Install 'nerdtree' vim-plug
vim-plug                       Install vim-plug
vim-surround                   Install 'surround' vim-plug
vim-tagbar                     Install 'tagbar' vim-plug
```
