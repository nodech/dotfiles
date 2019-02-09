" Default is WEB Development
"   for me

let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" -- OMNI SETUP for Javascript
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx', 'jsx'] }

" -- Typescript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}

let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]

" Set bin if you have many instalations
let g:deoplete#sources#ternjs#tern_bin = '/usr/bin/tern'
let g:deoplete#sources#ternjs#timeout = 1

" If completions should be returned when inside a literal. Default: 1
" let g:deoplete#sources#ternjs#in_literal = 0

" let g:deoplete#sources#ternjs#guess = 0
" let g:deoplete#sources#ternjs#sort = 0
" let g:deoplete#sources#ternjs#expand_word_forward = 0


let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#depths = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#filter = 0
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#include_keywords = 1
let g:deoplete#sources#ternjs#filetypes = [ 'jsx',  'javascript.jsx' ]
" let g:deoplete#sources#ternjs#omit_object_prototype = 0

:exec "source " . CONFIGS . "/.vimrc.after"
