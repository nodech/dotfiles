

let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

let g:deoplete#enable_at_startup = 0

" Here goes specific configurations
"Not supported yet on neovim
"Plug 'jeaye/color_coded'
Plug 'octol/vim-cpp-enhanced-highlight'

"Plug 'Shougo/neoinclude.vim'
"Plug 'Shougo/deoplete-clangx'

Plug 'Valloric/YouCompleteMe' " Advanced Autocompletion for multiple langs
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

set completeopt=menu,preview

:exec "source " . CONFIGS . "/.vimrc.after"
