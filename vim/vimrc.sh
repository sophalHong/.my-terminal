#!/bin/bash
if ! [ -x "$(command -v vim)" ]; then
    echo "Installing vim..." >&2
    sudo apt install -y vim;
fi

# Backup ~/.vim and ~/.vimrc
[ -d ~/.vim ] && mv ~/.vim ~/.vim_bak`date +%y%m%d_%H%M`
[ -f ~/.vimrc ] && mv ~/.vimrc ~/.vimrc_bak`date +%y%m%d_%H%M`

mkdir ~/.vim
cat > ~/.vimrc << EOF
"==================Default setting===================
colorscheme peachpuff   " awesome colorscheme
"set background=dark
syntax enable           " enable syntax processing

"Indentation without hard tabs :
"set expandtab           " tabs are spaces
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
  filetype plugin indent on " Load indentation rules and plugins
endif

highlight LineNr ctermfg=grey
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
hi SpellBad ctermfg=yellow ctermbg=red
hi SpellCap ctermfg=none ctermbg=red
"==================End Default setting================

"==================Useful plugin=====================
"Plug 'Valloric/YouCompleteMe' "For C/C++/Objective-C/C++/CUDA
"Plug 'bundle/YCM-Generator', { 'branch': 'stable'}
"Plug 'fatih/vim-go' , { 'do': ':GoInstallBinaries' }
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'scrooloose/nerdtree' ":map <C-@> :NERDTreeToggle<CR>
"Plug 'majutsushi/tagbar' ":nnoremap <Space> :TagbarToggle<CR>

"Plug 'nathanaelkane/vim-indent-guides' ":map <c-i> :IndentGuidesToggle<CR>
"if exists(':IndentGuidesToggle')
"	let g:indent_guides_guide_size = 1
"	let g:indent_guides_auto_colors = 0
"	autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=235
"	autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237
"endif

"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"Plug 'VundleVim/Vundle.vim'

"======Autoload cscope.out=======
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose " suppress 'duplicate connection' error
        exe "cs add " . db . " " . path
        set cscopeverbose
        " else add the database pointed to by environment variable
    elseif \$CSCOPE_DB != ""
        cs add \$CSCOPE_DB
    endif
endfunction
au BufEnter /* call LoadCscope()
"==================================

EOF

echo "Updated ~/.vimrc";
