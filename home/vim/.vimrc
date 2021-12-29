call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-dadbod'

call plug#end()

let mapleader = ","

xnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExe)     db#op_exec()
nnoremap <expr> <Plug>(DBExeLine) db#op_exec() . '_'

xmap <leader>q  <Plug>(DBExe)
nmap <leader>q  <Plug>(DBExe)
omap <leader>q  <Plug>(DBExe)
nmap <leader>qq <Plug>(DBExeLine)
