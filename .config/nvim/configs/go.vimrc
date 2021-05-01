
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
"Plug 'peterhoeg/vim-qml'
"Plug 'fatih/vim-go'
"Plug 'zchee/deoplete-go', { 'do': 'make'}

" Config -> Go
"let g:go_fmt_autosave = 1
"let g:go_disable_autoinstall = 0

" Config -> Go -> deoplete-go
"let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
"let g:deoplete#sources#go#use_cache = 1

" Config->go -> Linters
" let g:ale_completion_enabled = 0 " Make sure it's not on

"let g:go_highlight_functions = 1
"let g:go_highlight_extra_types = 1
"let g:go_highlight_methods = 1
"let g:go_highlight_structs = 1
"let g:go_highlight_interfaces = 1
"let g:go_highlight_operators = 1
"let g:go_highlight_build_constraints = 1
"let g:go_highlight_cgo = 1

"let g:go_auto_sameids = 1
"let g:go_auto_type_info = 1

"let g:tagbar_type_go = {
"    \ 'ctagstype' : 'go',
"    \ 'kinds'     : [
"        \ 'p:package',
"        \ 'i:imports:1',
"        \ 'c:constants',
"        \ 'v:variables',
"        \ 't:types',
"        \ 'n:interfaces',
"        \ 'w:fields',
"        \ 'e:embedded',
"        \ 'm:methods',
"        \ 'r:constructor',
"        \ 'f:functions'
"    \ ],
"    \ 'sro' : '.',
"    \ 'kind2scope' : {
"        \ 't' : 'ctype',
"        \ 'n' : 'ntype'
"    \ },
"    \ 'scope2kind' : {
"        \ 'ctype' : 't',
"        \ 'ntype' : 'n'
"    \ },
"    \ 'ctagsbin'  : 'gotags',
"    \ 'ctagsargs' : '-sort -silent'
"\ }

":exec "source " . CONFIGS . "/.vimrc.after"

"set completeopt=menu,preview

" Keymap->GoLang
"noremap <leader>gi :GoImport 
"noremap <leader>gg :GoImports<CR>

" Fix C-T
"nmap <silent> <C-T> :Windows<CR>
