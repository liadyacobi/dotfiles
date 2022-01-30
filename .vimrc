:set number
:set tabstop=2

call plug#begin()
Plug 'tabnine/YouCompleteMe'
Plug 'frazrepo/vim-rainbow'
Plug 'mhartington/oceanic-next'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" Theme
 syntax enable
" for vim 8
 if (has("termguicolors"))
  set termguicolors
 endif

colorscheme OceanicNext

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

map ; :Files<CR>

let g:indentLine_char = '⦙'
