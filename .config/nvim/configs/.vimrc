""
"" Node vimrc.
""

"""
""" VIM Configs
"""
set number
set rnu
set encoding=utf-8
set expandtab                  " Convert tabs to spaces
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
map <leader>gd :colorscheme hybrid<CR>
map <leader>gw :colorscheme Tomorrow<CR>

" Auto->View update
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

"""
""" /VIM.Configs
"""

"""
""" Plugin.Configs
"""

call plug#begin("$HOME/.config/nvim/bundle")

" Quick comment/uncomment
Plug 'scrooloose/nerdcommenter' " autocomment

" Git related
Plug 'airblade/vim-gitgutter' " git modification status (on numbers)
Plug 'tpope/vim-fugitive'     " Git command wrappers
Plug 'cohama/agit.vim'

" Auto Completion
"Plug 'Valloric/YouCompleteMe'                                 " Advanced Autocompletion for multiple langs
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Dark Powered neo-completion
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Linter
"Plug 'scrooloose/syntastic' " Syntax check with lots of validators
Plug 'w0rp/ale'             " Syntax check with lots of validators

" Highlights
Plug 'groenewege/vim-less'          " less syntax
Plug 'digitaltoad/vim-jade'         " jade syntax
Plug 'pangloss/vim-javascript'      " javascript syntax
Plug 'HerringtonDarkholme/yats.vim' " typescript syntax
Plug 'mxw/vim-jsx'                  " JSX Syntax
Plug 'isRuslan/vim-es6'             " es6 syntax
Plug 'plasticboy/vim-markdown'
Plug 'tikhomirov/vim-glsl'          " Shaders
Plug 'GutenYe/json5.vim'            " JSON with comments highlight
Plug 'tomlion/vim-solidity'         " Wanna eth?

" Tools
Plug 'godlygeek/tabular'             " Helps with alignments (E.g. this comments)
Plug 'tpope/vim-obsession'           " Should be used by ressurect.. Not using right now
Plug 'mbbill/undotree'               " Shows Undo Tree (rarely used)
Plug 'unblevable/quick-scope'        " Highlight characters when pressing `f, F, t`
Plug 'tpope/vim-surround'            " Auto Surrounding some stuff
Plug 'simeji/winresizer'             " Resize windows quickly <leader>e
Plug 'Raimondi/delimitMate'          " automatic closing of quotes, parenthesis etc.
Plug 'editorconfig/editorconfig-vim'
Plug 'wakatime/vim-wakatime'
Plug 'terryma/vim-multiple-cursors'  " multiple cursors, rarely used
Plug 'mileszs/ack.vim'
Plug 'Mizuchi/vim-ranger'            " Opens file explorer in ranger cli tool
Plug 'majutsushi/tagbar'
Plug 'aperezdc/vim-template'         " Custom templates for languages (on empty files.)
Plug 'mhinz/vim-rfc'                 " RFC Database query

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Colorschemes
Plug 'flazz/vim-colorschemes' " Catalogue of colors

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

" Remap Paste, keeps the clipboard/yank
xnoremap <leader>p "_dP

" Plugin configs
" Configs->vim-fugitive
set statusline+=[%n]\ %<%.99f\ %h%w%m%r%{SL('CapsLockStatusline')}%y%{SL('fugitive#statusline')}%#ErrorMsg#%{SL('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P

" Configs->quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Configs->Ack.vim
" Use silver_seracher as search engine
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
""" /Ack.vim

" Configs->vim-javascript
let g:javascript_plugin_jsdoc = 1

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
\   'c': [ 'clangcheck' ]
\}

let g:ale_fixers = {
\   'typescript': ['tslint']
\}

" Config->vim-template
let g:templates_directory='~/.config/nvim/templates/'

""" Configs.FZF
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

map <silent> <leader>lb :Buffers<CR>
map <silent> <leader>lf :Files<CR>
nmap <silent> <leader>lw :Windows<CR>
nmap <silent> <leader>lg :GFiles?<CR>
""" /Configs.FZF

""
"" Autocompletion configurations
""

" COC Configurations
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

nnoremap <silent> <leader>lc :<C-u>CocList<CR> " List commands
"
" /Coc configurations

" Configs->Deoplete
"let g:deoplete#enable_at_startup = 1

""
"" / Autocompletion configurations
""

" Keymap->winresizer
let g:winresizer_start_key = "<leader>e"
let g:winresizer_vert_size = 5

" Config and Keymap->MultiCursor
let g:multi_cursor_use_default_mapping   = 0
let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0

" Defaults
"let g:multi_cursor_use_default_mapping = 1
"let g:multi_cursor_start_word_key      = '<C-n>'
"let g:multi_cursor_select_all_word_key = '<A-n>'
"let g:multi_cursor_start_key           = 'g<C-n>'
"let g:multi_cursor_select_all_key      = 'g<A-n>'
"
let g:multi_cursor_start_word_key      = '<leader>mw'
let g:multi_cursor_select_all_word_key = '<leader>ma'
let g:multi_cursor_start_key           = 'g<leader>mw'
let g:multi_cursor_select_all_key      = 'g<leader>ma'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" Keymap->vim-choosewin
nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

" Keymap->Tabmoves
map <silent> <leader>tn :tabmove +1<CR>
map <silent> <leader>tp :tabmove -1<CR>

" Keymap->Terminal
tnoremap <C-]> <c-\><c-n>

" Keymap->NerdComment
nmap <C-;> <Leader>ci " Uncomment

" Custom commands
command JSrun execute '!node '.shellescape(@%, 1)<CR>

" Use true color in terminal.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
