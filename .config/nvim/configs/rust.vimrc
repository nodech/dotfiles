
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plugin 'wting/rust.vim'

:exec "source " . CONFIGS . "/.vimrc.after"
