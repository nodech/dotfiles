
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plug 'sebastianmarkow/deoplete-rust'
"Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'timonv/vim-cargo'

let g:racer_cmd=$HOME . "/.cargo/bin/racer"
let g:racer_experimental_completer = 1

let g:deoplete#sources#rust#racer_binary=$HOME . "/.cargo/bin/racer"
let g:deoplete#sources#rust#rust_source_path=$HOME . "/.rust/rust-1.30/src"
let g:deoplete#sources#rust#show_duplicates=1

:exec "source " . CONFIGS . "/.vimrc.after"
