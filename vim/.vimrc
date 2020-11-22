"set syntax=on
syntax on

set shiftwidth=2
set number

set wrap

set expandtab


set encoding=utf-8
set smartindent

" Include only uppercase words with uppercase search term
set smartcase
set incsearch


call plug#begin('~/.vim/plugged')
Plug 'sainnhe/gruvbox-material'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-fugitive'
"Plug 'valloric/youcompleteme'
Plug 'scrooloose/nerdtree'
"ctrlp is for search but it seams that fzf is more powerfull, nerdtree by the
"other hand allow to explore files
Plug 'kien/ctrlp.vim' 
"A Vim plugin which shows a git diff in the sign column. It shows which lines have been added, modified, or removed:

Plug 'airblade/vim-gitgutter'

Plug 'frazrepo/vim-rainbow'
Plug 'jiangmiao/auto-pairs'
"Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline' "status buttom bar
"engine snippets
Plug 'sirver/ultisnips'
"snippets 
Plug 'honza/vim-snippets'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'



"tab autocomplte snippets 

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


" Initialize plugin system
call plug#end()
set signcolumn=yes

"autocmd vimenter * NERDTree

let mapleader=","
"noremap <Leader>W :w !sudo tee % > /dev/null
nnoremap <c-p> <esc>:CtrlP<cr>
"map to fzf
nnoremap <c-o> <esc>:Files<cr>

"Ctrl+n 
map <C-n> :NERDTreeToggle<CR> 

if executable('rg')
  let g:rg_derive_root='true'
endif

nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gr <Plug>(coc-references)

nmap <leader>j :jumps <CR>
nnoremap <C-p> :GFiles <CR>

map <leader>tn :tabnew<cr>
map <leader>tm :tabmove

colorscheme gruvbox-material

