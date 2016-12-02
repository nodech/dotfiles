
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plug 'peterhoeg/vim-qml'
Plug 'fatih/vim-go'

" Config -> Go
let g:go_fmt_autosave = 1
let g:go_disable_autoinstall = 0

set number

map <silent> <F9> :GoRun<CR>
map <silent> <F5> :~/.configs/nvim/configs/go.vimrc<CR>
map <silent> <F3> :SyntasticCheck<CR>

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_cgo = 1

let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

:exec "source " . CONFIGS . "/.vimrc.after"

set completeopt=menu,preview

" Keymap->GoLang
noremap <leader>gi :GoImport 
noremap <leader>gg :GoImports<CR>

" Fix C-T
nmap <silent> <C-T> :Windows<CR>
