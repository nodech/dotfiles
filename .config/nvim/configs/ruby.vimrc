
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

Plugin 'vim-ruby/vim-ruby'

:exec "source " . CONFIGS . "/.vimrc.after"
