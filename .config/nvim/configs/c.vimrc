
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here goes specific configurations
"Not supported yet on neovim
"Plug 'jeaye/color_coded'

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

set completeopt=menu,preview

:exec "source " . CONFIGS . "/.vimrc.after"
