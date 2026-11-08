syntax on
set encoding=utf-8
set fileencoding=utf-8
set t_Co=256

set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

set laststatus=2
set number
set ruler
set cursorline
set incsearch
set hlsearch
set ignorecase

set splitright

" terminal
command Bt :bo term
command Ht :vert term

" plugins
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

call plug#end()

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
