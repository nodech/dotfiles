let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plugin 'fatih/vim-go'

" Config -> Go
let g:go_fmt_autosave = 0
map <silent> <F9> :GoRun<CR>
map <silent> <F5> :~/.vim/configs/go.vimrc<CR>

:exec "source " . CONFIGS . "/.vimrc.after"
