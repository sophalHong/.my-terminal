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
"set textwidth=80        " wrap text at 80 characters

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
"=======Key mappings=======
nnoremap bd :bdelete<Space>
nnoremap bq :bdelete<CR>
nnoremap bn :bnext<CR>
nnoremap bp :bprevious<CR>

nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>
nnoremap to :tabnew<CR>
nnoremap tc :tabclose<CR>
nnoremap ts :tabs<CR>
nnoremap te :tabedit<Space>
nnoremap tf :tabfind<Space>
nnoremap tm :tabmove<Space>

nnoremap we :edit<Space>
nnoremap wo :new<CR>
nnoremap ws :new<Space>
nnoremap wv :vnew<Space>
"resize
"Ctrl-w + , Ctrl-w - , Ctrl-w _
"Ctrl-w > , Ctrl-w < , Ctrl-w |
"Ctrl-w =

execute "set <A-1>=\e1"
execute "set <A-2>=\e2"
execute "set <A-3>=\e3"
execute "set <A-4>=\e4"
execute "set <A-5>=\e5"
execute "set <A-6>=\e6"
execute "set <A-7>=\e7"
execute "set <A-8>=\e8"
execute "set <A-9>=\e9"
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 1gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt

"==================Useful plugin=====================
"Plug 'Valloric/YouCompleteMe' "For C/C++/Objective-C/C++/CUDA
"Plug 'bundle/YCM-Generator', { 'branch': 'stable'}
"Plug 'fatih/vim-go' , { 'do': ':GoInstallBinaries' }
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

"Plug 'scrooloose/nerdtree'
autocmd VimEnter * if exists(":NERDTreeToggle") | exe "map <C-@> :NERDTreeToggle<CR>" | endif

"Plug 'majutsushi/tagbar'
autocmd VimEnter * if exists(":TagbarToggle") | exe	"nnoremap <Space> :TagbarToggle<CR>" | endif

"Plug 'nathanaelkane/vim-indent-guides' 
autocmd VimEnter * if exists(":IndentGuidesToggle") | exe "map <c-i> :IndentGuidesToggle<CR>" | endif
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=237

"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep = ""
let g:airline_right_sep = ""

"Plug 'rakr/vim-one'
"Plug 'altercation/vim-colors-solarized'
"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'morhetz/gruvbox'
"Plug 'gosukiwi/vim-atom-dark'
"Plug 'powerline/powerline'

"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-surround'

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

# Install vim-plug
if ! [ -x "$(command -v curl)" ]; then
    echo "Installing curl..." >&2
    sudo apt install -y curl;
fi
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

fi

# Add plug function into ~/.vimrc
if ! grep -q "^call plug#begin('~/.vim/plugged')" ~/.vimrc; then
	ed --quiet ~/.vimrc <<-END
	1i
	call plug#begin('~/.vim/plugged')
	Plug 'scrooloose/nerdtree'
	Plug 'majutsushi/tagbar', {'do': 'sudo apt install exuberant-ctags -y'}
	Plug 'nathanaelkane/vim-indent-guides' 
	Plug 'vim-airline/vim-airline', {'do': 'sudo apt install fonts-powerline -y'}
	Plug 'vim-airline/vim-airline-themes'
	Plug 'Chiel92/vim-autoformat'
	" Insert plugin here
	call plug#end()
	.
	w
	q
	END

	vim +slient +VimEnter +PlugInstall +qall
fi

echo "Updated ~/.vimrc";

echo "Add automatically adjust 'shiftwidth' and 'expandtab'"
mkdir -p ~/.vim/pack/tpope/start
cd ~/.vim/pack/tpope/start
git clone https://tpope.io/vim/sleuth.git
vim -u NONE -c "helptags sleuth/doc" -c q
echo 'let g:sleuth_automatic = 0' >> ~/.vimrc

echo "Done!"
