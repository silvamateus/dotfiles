" Used Jess Archer's config as base



set expandtab
set shiftwidth=2
set tabstop=2
set hidden
set signcolumn=yes:2
set relativenumber
set number
set termguicolors
set undofile
set spell
set title
set ignorecase
set smartcase
set wildmode=longest:full,full
set nowrap
set list
set listchars=tab:▸\ ,trail:·
set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitright
set clipboard=unnamedplus
set confirm
set exrc
set backup
set backupdir=~/.local/share/nvim/backup//
set updatetime=300 " Reduce time for highlighting other references
set redrawtime=10000 " Allow more time for loading syntax on large files
nmap <Leader>ed :edit ~/.config/nvim/init.vim
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>
nmap <leader>ec :edit ~/.config/nvim/coc-settings.json<cr>

map gf :edit <cfile><cr>


" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Paste replace visual selection without copying it
vnoremap <leader>p "_dP

" Open the current file in the default program
nmap <leader>x :!xdg-open %<cr><cr>



" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

" Got this idea from Jess Archer talk in VimCon
"
source ~/.config/nvim/plugins/coc.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/editorconfig.vim
source ~/.config/nvim/plugins/fugitive.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/javascript.vim
source ~/.config/nvim/plugins/typescript.vim


call plug#end()
doautocmd User PlugLoaded

"--------------------------------------------------------------------------
" Miscellaneous
"--------------------------------------------------------------------------

augroup FileTypeOverrides
    autocmd!
    " Use '//' instead of '/* */' comments
    autocmd FileType php, javascript, typescript setlocal commentstring=//%s
    autocmd TermOpen * setlocal nospell
augroup END
