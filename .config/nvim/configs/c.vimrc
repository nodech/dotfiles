
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here goes specific configurations

:exec "source " . CONFIGS . "/.vimrc.after"
