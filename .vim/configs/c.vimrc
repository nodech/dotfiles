let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plugin 'osyo-manga/vim-marching'

:exec "source " . CONFIGS . "/.vimrc.after"
