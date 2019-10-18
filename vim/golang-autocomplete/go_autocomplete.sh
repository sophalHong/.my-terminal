#!/bin/bash
if ! [ -x "$(command -v go)" ]; then
    echo "[ERROR] go is not installed !" && exit;
fi

if ! [ -x "$(go env GOPATH)" ]; then
    echo "[ERROR] GOPATH not found";
    echo "[Usage] export GOPATH=/path/to/working-dir"
    echo "[Usage] export GOBIN=/path/to/working-dir/bin"
    exit;
fi

# Install vim
if ! [ -x "$(command -v vim)" ]; then
    echo "Installing vim..." >&2
    sudo apt install -y vim;
fi

# Set vim default settings
[ ! -f ../vimrc.sh ] && 
	echo "NOT Found '../vimrc.sh' - set default vim" &&
	exit
bash ../vimrc.sh

# Install git if not yet installed
if ! [ -x "$(command -v git)" ]; then
    echo "Installing git..." >&2
    sudo apt install -y git;
fi

# Install vim-plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

fi

# Add plug function into ~/.vimrc
if ! grep -q "^call plug#begin('~/.vim/plugged')" ~/.vimrc; then
	ed --quiet ~/.vimrc <<-END
	1i
	call plug#begin('~/.vim/plugged')
	" Insert plugin here
	call plug#end()
	.
	w
	q
	END
fi

PlugBeginLine=`awk '/call plug#begin/{print NR; exit}' ~/.vimrc`

# Install vim-go Plugin
if grep -q "^Plug 'fatih/vim-go'" ~/.vimrc; then
    echo "fatih/vim-go is already installed!"
else
    echo "Insert fatih/vim-go for PlugInstall..."
    PlugBeginLine=$((PlugBeginLine + 1))
    ed --quiet ~/.vimrc <<-END
	${PlugBeginLine}i
	Plug 'fatih/vim-go' , { 'do': ':GoInstallBinaries' }
	.
	w
	q
	END

    vim +slient +VimEnter +PlugInstall +qall
fi

# Install yarn
if [ -x "$(command -v cmdtest)" ]; then
    echo "Removing cmdtest..." >&2
    sudo apt remove -y cmdtest; 
fi


if ! [ -x "$(command -v yarn)" ]; then
    echo "Installing yarn..." >&2

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee
    /etc/apt/sources.list.d/yarn.list

    sudo apt-get update && sudo apt-get install yarn -y;
fi

# Install coc.nvim (Conquer of Completion)
if grep -q "^Plug 'neoclide/coc.nvim'" ~/.vimrc; then
    echo "neoclide/coc.nvim is already installed!"
else
    echo "Insert neoclide/coc.nvim for PlugInstall..."
    PlugBeginLine=$((PlugBeginLine + 1))
    ed --quiet ~/.vimrc <<-END
	${PlugBeginLine}i
	Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
	.
	w
	q
	END

    vim +slient +VimEnter +PlugInstall +qall
fi

# Setup languageServer 
if ! [ -x "$(command -v gopls)" ]; then
    echo "[ERROR] Cannot find 'gopls' in environment PATH !"
    exit;
else
    cat > ~/.vim/coc-settings.json <<-EOF
	{
	  "languageserver": {
		"golang": {
		  "command": "gopls",
		  "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],
		  "filetypes": ["go"]
		}
	  }
	}
	EOF
fi

#read -d '' VAR << EOF
#EOF
#echo -e "${VAR}\n\n$(cat ~/.vimrc)" > ~/.vimrc

# Create Coc.nvim Default settings
coc_vim_LOC=~/.vim/plugged/coc.nvim/coc.vim
cat > $coc_vim_LOC << EOF
"==========Coc.nvim Default Settings=========
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, <C-g>u means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use [c and ]c to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: <leader>aap for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use :Format to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use :Fold to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }



" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
"============End of Coc.nvim=========
EOF

echo ""
echo '"===========Coc.nvim default settings=========' >> ~/.vimrc
echo "source $coc_vim_LOC" >> ~/.vimrc
