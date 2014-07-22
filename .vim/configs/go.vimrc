let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plugin 'fatih/vim-go'

" Config -> Go
let g:go_fmt_autosave = 0

:exec "source " . CONFIGS . "/.vimrc.after"
