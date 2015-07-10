" Default is WEB Development
"   for me
let g:CONFIGS = $HOME . "/.vim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" tern
Plugin 'marijnh/tern_for_vim'

" Try YCM for default configs
"let g:neocomplete#enable_at_startup = 0
"let g:neocomplete#force_overwrite_completefunc = 0
"Plugin 'Valloric/YouCompleteMe'

" Here should go specific configs


:exec "source " . CONFIGS . "/.vimrc.after"
