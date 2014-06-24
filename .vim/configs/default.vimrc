" Default is WEB Development
"   for me
let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plugin 'groenewege/vim-less'
Plugin 'digitaltoad/vim-jade'

:exec "source " . CONFIGS . "/.vimrc.after"
