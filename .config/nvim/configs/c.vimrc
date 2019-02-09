
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here goes specific configurations
"Not supported yet on neovim
"Plug 'jeaye/color_coded'

"let g:deoplete#enable_at_startup = 0

"Plug 'Valloric/YouCompleteMe' " Advanced Autocompletion for multiple langs
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/deoplete-clangx'
"Plug 'zchee/deoplete-clang'

set completeopt=menu,preview

:exec "source " . CONFIGS . "/.vimrc.after"
