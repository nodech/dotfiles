
let g:CONFIGS = $HOME . "/.config/nvim/configs"

:exec "source " . CONFIGS ."/.vimrc"

" Here should go specific configs
Plug 'wting/rust.vim'
Plug 'racer-rust/vim-racer'

let g:racer_cmd = "/Users/nod/.cargo/bin/racer"
let $RUST_SRC_PATH='/usr/local/rust/rust-1.8.0/src'

:exec "source " . CONFIGS . "/.vimrc.after"
