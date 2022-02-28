" settings
:set number
:set tabstop=2
:set linebreak
:set ignorecase
:set showmatch
:set cursorline
:set noswapfile
:set expandtab
:set confirm
:set incsearch

execute "set <M-j>=\ej"
execute "set <M-j>=\ej"
execute "set <M-j>=\ej"
execute "set <M-j>=\ej"
nmap <M-l> :tabprevious
nmap <M-h> :tabnext

" Move a line with ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z

" Plugs
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

" Key Mapping
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" search with space
map <space> /
map <C-space> ?

map \ :Files<CR>

" => Turn persistent undo on, means that you can undo even when you close a buffer/VIM
try
    set undodir=~/.vim/temp_dirs/undodir
    set undofile
catch
endtry

" Map auto complete of (, ", ', [
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

let g:indentLine_char = '⦙'
