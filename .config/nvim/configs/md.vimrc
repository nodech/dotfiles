
" This is for Markdown writing
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

Plug 'gabrielelana/vim-markdown'

:exec "source " . CONFIGS . "/.vimrc.after"
