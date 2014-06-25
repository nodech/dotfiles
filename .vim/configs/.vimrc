" Config file for ALL

" Set Configurations
set nocp
set encoding=utf-8
set expandtab
set nu
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
set wildignore=*.bak,*.o,*.e,*~
set wildmenu
set pastetoggle=<F2>
set laststatus=2
set mouse=a
set updatetime=2000

set directory=$HOME/.vim/tmp/
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


" Colors and fonts
syntax enable
colorscheme Tomorrow-Night

if has("gui_running")
  set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline
  set go-=R
  set go-=L
  set go-=r
endif

" FileType handlers
filetype plugin on
filetype plugin indent on
filetype off

" Init keymaps
let mapleader=","

" Keymap->Search highlights & special chars
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <C-K> :set list!<CR>

" Keymap->VisualIndent
vnoremap > > gv
vnoremap < < gv

" Keymap->Reload .vimrc
map <silent> <F5> :source ~/.vimrc<CR>

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

" Autos
" Auto->Automatically open and close the popup menu/preview window
au CursorMovedI, InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Auto->View update
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Load VUNDLE
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Load plugins
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'yegappan/grep'
Plugin 'mattn/emmet-vim'
Plugin 'Shougo/vimproc' " Needs compilation after installation
Plugin 'Shougo/neocomplete.vim'

" Plugin configs
" Configs->Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Configs->NERDTree
let NERDTreeChDirMode=2

" Configs->Emmet-vim
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<C-Z>'

" Configs->NeoComplete
let g:neocomplete#enable_at_startup = 1

" Configs->Gist
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_clip_command = 'pbcopy'

" Plugin Keymaps
" Keymap->NERDTree
map <silent> <F3> :NERDTreeTabsToggle<CR>
map <silent> <F4> :TagbarToggle<CR>
map <Leader>d     :NERDTreeToggle<CR>

" Keymap->NerdComment
nmap <C-;> <Leader>ci " Uncomment
