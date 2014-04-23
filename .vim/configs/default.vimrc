let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs

:exec "source " . CONFIGS . "/.vimrc.after"
