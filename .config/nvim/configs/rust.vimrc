
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plug 'sebastianmarkow/deoplete-rust'
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'

let g:deoplete#sources#rust#racer_binary=$HOME . "/.cargo/bin/racer"
let g:deoplete#sources#rust#rust_source_path=$HOME . "/.rust/rust-1.22.1/src"
let g:deoplete#sources#rust#show_duplicates=1

:exec "source " . CONFIGS . "/.vimrc.after"
