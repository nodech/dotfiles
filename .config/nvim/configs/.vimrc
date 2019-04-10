" Config file for ALL

" Set Configurations
set number
set rnu
set encoding=utf-8
set expandtab                           " Convert tabs to spaces
set backspace=indent,eol,start
set browsedir=current
set complete+=k
set history=50
set hlsearch
set incsearch
set listchars=tab:>.,eol:\$
set nowrap
set popt=left:8pc,right:3pc
set ruler
set showcmd
set shiftwidth=2
set tabstop=2
set visualbell
set pastetoggle=<F2>
set laststatus=2
set mouse=a
set updatetime=2000

" Config->folds
set foldenable
set foldmethod=syntax
set foldnestmax=5
set foldlevelstart=100

" Config->temp files.
set directory=$HOME/.config/nvim/tmp/
set nobackup
set nowritebackup
set noerrorbells

set noautoread
set noautowrite
set noautowriteall

set wildmenu
set wildmode=list:longest,full

set cursorline
set lazyredraw
set hidden

set listchars=tab:▸\ ,eol:¬
set list

set autoindent
set smartindent
set completeopt=menuone,menu,longest,preview

"Ignore files
set wildignore+=tags               " Ignore tags when globbing.
set wildignore+=tmp/**             " ...Also tmp files.
set wildignore+=public/uploads/**  " ...Also uploads.
set wildignore+=public/images/**   " ...Also images.
set wildignore+=node_modules       " ...Also node_modules

" TrueColor
set termguicolors

" FileType handlers
filetype off

" Init keymaps
let mapleader=","

" Clipboard Switches
map <C-c> :set clipboard=unnamedplus<CR>
"map <C-S-c> :set clipboard=unnamed<CR>
map <C-x> :set clipboard=<CR>

" Keymap->Search highlights & special chars
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <C-K> :set list!<CR>

" Keymap->Fold controls
nnoremap <leader>zc :set foldlevel=1<CR>
nnoremap <leader>zo :set foldlevel=99<CR>
nnoremap <leader>zf :set foldlevel=

" Activate `.` in vnoremap
vnoremap . :norm.<CR>

" Keymap->VisualIndent
vnoremap > > gv
vnoremap < < gv

" Keymap->move lines
vnoremap K  :m -2<CR> gv
vnoremap J  :m +1<CR> gv

" Keymap->Reload .vimrc
"map <silent> <F5> :source $HOME/.config/nvim/configs/.vimrc<CR>

" Keymap->Navigate between tabs
nnoremap <C-N> gt
nnoremap <C-P> gT

" Switch colors in vim
"map <leader>gd :colorscheme Tomorrow-Night<CR>
"map <leader>gd :colorscheme Tomorrow-Night-Bright<CR>
"map <leader>gd :colorscheme codedark<CR>
map <leader>gd :colorscheme hybrid<CR>
map <leader>gw :colorscheme Tomorrow<CR>

" Autos
"" Auto->Automatically open and close the popup menu/preview window
"au CursorMovedI, InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Auto->View update
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

call plug#begin("$HOME/.config/nvim/bundle")

" Load plugins
Plug 'scrooloose/nerdcommenter' " autocomment

Plug 'airblade/vim-gitgutter' " git modification status (on numbers)
Plug 'tpope/vim-fugitive' " Git command wrappers


"Plug 'Valloric/YouCompleteMe' " Advanced Autocompletion for multiple langs
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Dark Powered neo-completion

Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim' " Gist posting
Plug 'mileszs/ack.vim'
Plug 'mattn/emmet-vim'
"Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags'

Plug 'Mizuchi/vim-ranger' " Opens file explorer in ranger cli tool
Plug 'majutsushi/tagbar'
Plug 'aperezdc/vim-template' " Custom templates for languages
"Plug 'scrooloose/syntastic' " Syntax check with lots of validators
Plug 'w0rp/ale' " Syntax check with lots of validators
"Plug 'neomake/neomake'

" Default Languages
Plug 'groenewege/vim-less'
Plug 'digitaltoad/vim-jade'
Plug 'pangloss/vim-javascript'
"Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mxw/vim-jsx'
Plug 'isRuslan/vim-es6'
Plug 'plasticboy/vim-markdown'
Plug 'tikhomirov/vim-glsl'
Plug 'mhinz/vim-rfc'
Plug 'GutenYe/json5.vim'

" Tools
Plug 'godlygeek/tabular' " Tabularize
Plug 'tpope/vim-obsession' " Should be used by ressurect.. Not using right now
Plug 'mbbill/undotree' " Shows Undo Tree (rarely used)
Plug 'unblevable/quick-scope' " Works when truecolor is on
Plug 'tpope/vim-surround' " Auto Surrounding some stuff
Plug 't9md/vim-choosewin'
Plug 'simeji/winresizer'
Plug 'cohama/agit.vim'
Plug 'Raimondi/delimitMate'
Plug 'tomlion/vim-solidity'
Plug 'editorconfig/editorconfig-vim'
Plug 'wakatime/vim-wakatime'


"try colorschemes
Plug 'flazz/vim-colorschemes'
"Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'connorholyday/vim-snazzy'
Plug 'tomasiser/vim-code-dark'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction

" Custom Configs on filetypes
" Markdown
au FileType markdown set nofoldenable
au FileType markdown set wrap
au FileType markdown highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au FileType markdown match OverLength /\%101v.\+/


" AutoRelative Numbers
au FocusLost * :set rnu!
au FocusGained * :set rnu

autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu

" Formatter
"autocmd FileType javascript.jsx,javascript setlocal formatprg=prettier\ --stdin
"noremap <leader>p gggqG

" Remap Paste
xnoremap <leader>p "_dP

" Custom fold control


" Ruby config
let g:ruby_host_prog="$HOME/.gem/ruby/2.5.0/bin/neovim-ruby-host"

" Plugin configs
" Configs->vim-fugitive
set statusline+=[%n]\ %<%.99f\ %h%w%m%r%{SL('CapsLockStatusline')}%y%{SL('fugitive#statusline')}%#ErrorMsg#%{SL('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P


" Configs->quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Configs->Ack.vim
" Use ag as searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Configs->vim-javascript
let g:javascript_plugin_jsdoc = 1

" Configs->Emmet-vim
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-Z>'

" Config->GitGutter
let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_removed='◢'
let g:gitgutter_sign_removed_first_line='◥'
let g:gitgutter_sign_modified_removed='◢'
"let g:gitgutter_highlight_lines = 1

" Configs->ALE
let g:ale_lint_on_text_changed = 'normal'
let g:ale_linters = {
\   'typescript': ['tslint'],
\   'javascript': ['eslint', 'tsserver'],
\   'go': [ 'golint', 'govet', 'gometalinter', 'gosimple', 'staticheck' ],
\   'c': [ 'clang', 'gcc', 'clang-format', 'cpplint']
\}

let g:ale_fixers = {
\   'typescript': ['tslint']
\}

" Config->vim-template
let g:templates_directory='~/.config/nvim/templates/'

" Configs->Gist
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_clip_command = 'xsel -i --clipboard'

" Configs->FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Configs->Deoplete
let g:deoplete#enable_at_startup = 1

" Plugin Keymaps
" Keymap->vim-ranger
noremap <leader>f :tabe %:p:h<CR>

" Keymap->winresizer
let g:winresizer_start_key = "<leader>e"
let g:winresizer_vert_size = 5

" Keymap->vim-choosewin
nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

" Keymap->Tabmoves
map <silent> <leader>tn :tabmove +1<CR>
map <silent> <leader>tp :tabmove -1<CR>

" Keymap->FZF
map <silent> <leader>lb :Buffers<CR>
map <silent> <leader>lf :Files<CR>
nmap <silent> <leader>lw :Windows<CR>

" Keymap->Terminal
tnoremap <C-]> <c-\><c-n>

" Keymap->NerdComment
nmap <C-;> <Leader>ci " Uncomment

" Custom commands
command JSrun execute '!node '.shellescape(@%, 1)<CR>

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
