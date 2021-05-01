
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

let g:deoplete#enable_at_startup = 0

" Here goes specific configurations
"Not supported yet on neovim
"Plug 'jeaye/color_coded'

" In C language scope, we want header files to be detected as C language,
" instead of CPP.
" let g:c_syntax_for_h=1

"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

"set completeopt=menu,preview

:exec "source " . CONFIGS . "/.vimrc.after"
