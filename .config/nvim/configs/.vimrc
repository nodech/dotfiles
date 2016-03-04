" Config file for ALL

"set runtimepath=$HOME/.config/nvim/

" Set Configurations
set encoding=utf-8
set expandtab
set number
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
set wildmenu
set pastetoggle=<F2>
set laststatus=2
set mouse=a
set updatetime=2000

set directory=$HOME/.config/nvim/tmp/
set nobackup
set nowritebackup
set noerrorbells

set noautoread
set noautowrite
set noautowriteall

set cursorline
set lazyredraw
set hidden

set listchars=tab:▸\ ,eol:¬
set list

set autoindent
set smartindent
set completeopt=menuone,menu,longest

"Ignore files
set wildignore+=tags               " Ignore tags when globbing.
set wildignore+=tmp/**             " ...Also tmp files.
set wildignore+=public/uploads/**  " ...Also uploads.
set wildignore+=public/images/**   " ...Also images.
set wildignore+=node_modules       " ...Also node_modules

" Colors and fonts
syntax enable
colorscheme Tomorrow-Night-Bright

" FileType handlers
filetype off

" Init keymaps
let mapleader=","

" Clipboard Switches
map <C-c> :set clipboard=unnamed<CR>
map <C-x> :set clipboard=<CR>

" Keymap->Search highlights & special chars
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <C-K> :set list!<CR>

" Activate `.` in vnoremap
vnoremap . :norm.<CR>

" Keymap->VisualIndent
vnoremap > > gv
vnoremap < < gv

" Keymap->Reload .vimrc
map <silent> <F5> :source $HOME/.config/nvim/.vimrc<CR>

" Keymap->Completion
inoremap ,, <C-X><C-O>

" Keymap->Window size change normal
nnoremap < <c-w>10<
nnoremap > <c-w>10>
nnoremap + <c-w>4+
nnoremap = <c-w>4+
nnoremap - <c-w>4-

" Keymap->Navigate between windows
nmap <A-n> <C-W>w
nmap <A-p> <C-W>W

" Keymap->Navigate between tabs
nnoremap <C-N> gt
nnoremap <C-P> gT

" Switch colors in vim
map <leader>gd :colorscheme Tomorrow-Night-Bright<CR>
map <leader>gw :colorscheme Tomorrow<CR>

" Autos
" Auto->Automatically open and close the popup menu/preview window
au CursorMovedI, InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Auto->View update
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Load VUNDLE
source $HOME/.config/nvim/bundle/vim-plug/plug.vim
call plug#begin("$HOME/.config/nvim/bundle")

" Load plugins
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'tpope/vim-fugitive'
Plug 'mileszs/ack.vim'
Plug 'mattn/emmet-vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'majutsushi/tagbar'
Plug 'aperezdc/vim-template'
Plug 'scrooloose/syntastic'
Plug 'groenewege/vim-less'
Plug 'digitaltoad/vim-jade'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'isRuslan/vim-es6'
Plug 'benmills/vimux'
Plug 'tpope/vim-obsession'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'Valloric/YouCompleteMe'
Plug 'mbbill/undotree'
Plug 'unblevable/quick-scope'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Plugin configs
"" Configs->NERDTree
"let NERDTreeChDirMode=2
let g:nerdtree_tabs_open_on_gui_startup=0

" Configs->quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Configs->Ack.vim
" Use ag as searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Config->VimFiler
let g:vimfiler_as_default_explorer = 1

" Configs->Emmet-vim
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-Z>'

" Configs->syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']

" Config->vim-template
let g:templates_directory='~/.config/nvim/templates/'

" Configs->Gist
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_clip_command = 'pbcopy'

" Configs->FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }


" Plugin Keymaps
" Keymap->NERDTree
map <silent> <F3> :NERDTreeTabsToggle<CR>
map <silent> <F4> :TagbarToggle<CR>

" Keymap->FZF
map <silent> <C-B> :Buffers<CR>
map <silent> <C-J> :Files<CR>
nmap <silent> <C-T> :Windows<CR>

" Keymap->NerdComment
nmap <C-;> <Leader>ci " Uncomment
