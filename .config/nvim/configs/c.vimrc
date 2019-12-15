
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

let g:deoplete#enable_at_startup = 0

" Here goes specific configurations
"Not supported yet on neovim
"Plug 'jeaye/color_coded'

" In C language scope, we want header files to be detected as C language,
" instead of CPP.
let g:c_syntax_for_h=1

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'arakashic/chromatica.nvim'

let g:chromatica#enable_at_startup=1

" MacOS config
let g:chromatica#libclang_path='/usr/local/opt/llvm/lib'

"Plug 'Shougo/neoinclude.vim'
"Plug 'Shougo/deoplete-clangx'
"Plug 'zchee/deoplete-clang'

set completeopt=menu,preview

:exec "source " . CONFIGS . "/.vimrc.after"
