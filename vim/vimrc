"" ===============Vundle===============
"set nocompatible              " be iMproved, required
"filetype off                  " required
"
""set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
"" alternatively, pass a path where Vundle should install plugins
""call vundle#begin('~/some/path/here')
"
"" let Vundle manage Vundle, required
"Plugin 'VundleVim/Vundle.vim'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'bundle/YCM-Generator', { 'branch': 'stable'}
"
"" All of your Plugins must be added before the following line
"call vundle#end()            " required
"filetype plugin indent on    " required
"" To ignore plugin indent changes, instead use:
""filetype plugin on
""
"" Brief help
"" :PluginList       - lists configured plugins
"" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"" :PluginSearch foo - searches for foo; append `!` to refresh local cache
"" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
""
"" see :h vundle for more details or wiki for FAQ
"" Put your non-Plugin stuff after this line
""
" ================clang===============
" path to directory where library can be found
let g:clang_library_path='/root/.vim/bundle/YouCompleteMe/third_party/ycmd/libclang.so.7'
" ====================================
"let g:ycm_global_ycm_extra_conf = '~/root/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"" turn on completion in comments
let g:ycm_complete_in_comments=1
"" load ycm conf by default
let g:ycm_confirm_extra_conf=0
"" turn on tag completion
let g:ycm_collect_identifiers_from_tags_files=1
"" only show completion as a list instead of a sub-window
set completeopt-=preview
"" start completion from the first character
let g:ycm_min_num_of_chars_for_completion=1
"" don't cache completion items
let g:ycm_cache_omnifunc=0
"" complete syntax keywords
let g:ycm_seed_identifiers_with_syntax=1


"============================================
colorscheme peachpuff   " awesome colorscheme
"set background=dark
syntax enable           " enable syntax processing
set tabstop=4       	" number of visual spaces per TAB
set shiftwidth=4
set softtabstop=4   	" number of spaces in tab when editing
set expandtab       	" tabs are spaces
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set ruler
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase			" Do case insenitive matching
set smartcase			" Do smart case matching
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
"set textwidth=80
if has("syntax")
   syntax on			" syntax highlighting
endif
if has("autocmd")       " Jump to last position when reopening file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif   
if has("autocmd")		" Load indentation rules and plugins
  filetype plugin indent on
endif

highlight LineNr ctermfg=grey
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
hi SpellBad ctermfg=yellow ctermbg=red 
hi SpellCap ctermfg=none ctermbg=red 
"hi Pmenu ctermbg=238 gui=bold
"Pmenu – normal item
"PmenuSel – selected item
"PmenuSbar – scrollbar
"PmenuThumb – thumb of the scrollbar

"  Autoload cscope.out============
function! LoadCscope()
  let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose " suppress 'duplicate connection' error
        exe "cs add " . db . " " . path
        set cscopeverbose
        " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != "" 
        cs add $CSCOPE_DB
    endif
endfunction
au BufEnter /* call LoadCscope()
"==================================
"cs add $CSCOPE_DB

"source ~/.vim/plugin/cscope_maps.vim
" Open tag in vertical split
"map <C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"set cindent
"set smartindent
"set colorcolumn=+1
"set laststatus=2
"set smarttab
"cs add .
"set cst
"highlight ColorColumn ctermbg=0 guibg=lightgrey
"set fencs=ucs-bom,utf-8,euc-kr.latin1
"filetype plugin on
"filetype on
"autocmd Filetype cpp set ts=8 sw=2 smarttab
"if has('gui_running')
   " do something
"else 
   "    " if running in terminal
  "       " tell vim to use 256 colors
   
   "set background=dark   
 
   "set t_Co=16
   "           
   "              " tell Solarized to use the 258 degraded color mode
   "let g:solarized_termcolors=16
"endif
"autocmd CursorMovedI * silent! TlistHighlightTag
"set ut=500
