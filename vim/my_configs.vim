"autocmd vimenter * NERDTree
filetype off

call pathogen#infect()
call pathogen#helptags()

syntax on

filetype plugin on
filetype plugin indent on

set number
set expandtab "Indent with spaces
set pastetoggle=<F2>

"Show » for earch indent
set list lcs=tab:\»\ 
let g:vim_markdown_folding_disabled = 1
