
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

Plug 'vim-ruby/vim-ruby'

:exec "source " . CONFIGS . "/.vimrc.after"
