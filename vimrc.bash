#!/bin/bash
if ! [ -x "$(command -v vim)" ]; then
    echo "Installing vim..." >&2
    sudo apt install -y vim;
fi

cat > ~/.vimrc << EOF
"==================Default setting===================
colorscheme peachpuff   " awesome colorscheme
"set background=dark
syntax enable           " enable syntax processing

"Indentation without hard tabs :
set expandtab           " tabs are spaces
set softtabstop=4       " number of spaces in tab when editing
set tabstop=4           " number of visual spaces per TAB
set shiftwidth=4        " automatically indent next line (if, {, ...)
"softtabstop, tabstop, shiftwidth should be the same value

set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set ruler               " Display line, column, virtual column number
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " Do case insenitive matching
set smartcase           " Do smart case matching
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
set textwidth=80        " wrap text at 80 characters

if has("syntax")
   syntax on            " syntax highlighting
endif
if has("autocmd")       " Jump to last position when reopening file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
if has("autocmd")       " Load indentation rules and plugins
  filetype plugin indent on
endif

highlight LineNr ctermfg=grey
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
hi SpellBad ctermfg=yellow ctermbg=red
hi SpellCap ctermfg=none ctermbg=red
"==================End Default setting================
EOF

echo "Updated ~/.vimrc";
