"""
" nod_vim version 20130223
"""

"-- VIM then VI
set nocompatible


"-- highlight on
syntax enable
color Tomorrow-Night

if has("gui_running")
  set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline
  set go-=R
  set go-=L
  set go-=r
endif

"Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'

"
"-- file type detection
filetype plugin on
filetype plugin indent on
filetype off

"-- search highlight redraw
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <C-K> :set list!<CR>

"-- (example: NERD_COMMENT ,cc)
let mapleader=","


"-- sets
set encoding=utf-8
set expandtab                   " Insert spaces not tabs
set nu                          " Show line numbers
set autoread                    " Read open files again when changed outside Vim
set autowrite                   " Write a modified buffer on each :next , ...
set backspace=indent,eol,start  " Backspacing over everything in insert mode
set browsedir=current           " Which directory to use for the file browser
set complete+=k                 " Scan the files given with the 'dictionary' option
set history=50                  " Keep 50 lines of command line history
set hlsearch                    " Highlight the last used search pattern
set incsearch                   " Do incremental searching
set listchars=tab:>.,eol:\$     " Strings to use in 'list' mode
set nowrap                      " Do not wrap lines
set popt=left:8pc,right:3pc     " Print options
set ruler                       " Show the cursor position all the time
set shiftwidth=2                " Number of spaces to use for each step of indent
set showcmd                     " Display incomplete commands
set tabstop=2                   " Number of spaces that a <Tab> counts for
set visualbell                  " Visual bell instead of beeping
set wildignore=*.bak,*.o,*.e,*~ " Wildmenu: ignore these extensions
set wildmenu                    " Command-line completion in an enhanced mode
"set autochdir                   " Automatically change current directory
set pastetoggle=<F2>            " Paste mode turn on/off with F2
set laststatus=2                " Show status line all the time
set mouse=a                     " To Copy to clipboard easily
set noautoread
set updatetime=2000
set directory=$HOME/.vim/tmp/
set nobackup                    " Let's have a look
set nowritebackup               "   How we gonna leave without backup
set noerrorbells
set noautowrite
set noautowriteall
set cursorline
set lazyredraw
set hidden

set listchars=tab:▸\ ,eol:¬
set list

"
"-- indents..
set autoindent
set smartindent

"--view options auto load/save
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" infect pathegon
execute pathogen#infect()
execute pathogen#helptags()

" --- Grep Module config

let Grep_Skip_Dirs  = 'node_modules .git'
let Grep_Skip_Files = '*.bak *~ tags *.flv *.pdf *.jpg *.gif *.png *.node'

" --- load javascript for html
au FileType html set ft=html.javascript
au FileType c,cpp :TagbarOpen

" ------------
" --- MAPS ---
" ------------

map <silent> <F3>  :NERDTreeTabsToggle<CR>
map <silent> <F4> :TagbarToggle<CR> 
map <silent> <F5> :source ~/.vimrc<CR>

"map <silent> <F7>  <Esc>:cprevious<CR>
"map <silent> <F8>  <Esc>:cnext<CR>

"-- NERD Tree Tabs
map <Leader>d :NERDTreeToggle<CR>

"-- NERD TREE
let NERDTreeChDirMode=2
"nnoremap <leader>n :NERDTree .<CR>

" Load Plugins till we map things

"-- indent +/- in visual/select mode(without deselecting)
vnoremap > > gv
vnoremap < < gv

"-- change window width in normal mode
nnoremap < <c-w>10<
nnoremap > <c-w>10>
nnoremap + <c-w>4+
nnoremap = <c-w>4+
nnoremap - <c-w>4-

"-- navigate between windows
nmap <A-n> <C-W>w
nmap <A-p> <C-W>W

"-- remap multiple cursors
let g:multi_cursor_use_default_mapping=0

let g:multi_cursor_next_key='<C-f>'
let g:multi_cursor_prev_key='<C-h>'
let g:multi_cursor_skip_key='<C-j>'
let g:multi_cursor_quit_key='<Esc>'

"-- navigate between tabs
nnoremap <C-N> gt
nnoremap <C-P> gT

"-- comment uncomment
nmap <C-;> ,ci
"
"-- completion remaped
inoremap ,, <C-X><C-O>

" ------------
" ---/MAPS ---
" ------------

" automatically open and close the popup menu/preview window
au CursorMovedI, InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest

" auto close options when exiting insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

syntax on
