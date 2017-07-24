
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

Plug 'frigoeu/psc-ide-vim'
Plug 'raichoo/purescript-vim'

:exec "source " . CONFIGS . "/.vimrc.after"
