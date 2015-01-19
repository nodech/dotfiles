let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
let g:neocomplete#enable_at_startup = 0
let g:neocomplete#force_overwrite_completefunc = 0
Plugin 'Valloric/YouCompleteMe'

:exec "source " . CONFIGS . "/.vimrc.after"
