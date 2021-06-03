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

" Smart case, but we need to have ignorecase as well
" Use \c or \C to override behaviour
set ignorecase
set smartcase

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
"map <leader>gd :colorscheme hybrid<CR>
map <leader>gd :set background=dark<CR>
"map <leader>gw :colorscheme Tomorrow<CR>
map <leader>gw :set background=light<CR>

" Auto->View update
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" Auto->Relative Numbers
au FocusLost * :set rnu!
au FocusGained * :set rnu
autocmd InsertEnter * :set rnu!
autocmd InsertLeave * :set rnu

" Keymap->Tabmoves
map <silent> <leader>tn :tabmove +1<CR>
map <silent> <leader>tp :tabmove -1<CR>

" Keymap->Terminal
tnoremap <C-]> <c-\><c-n>

" {{{ Copy/Paste across ssh sessions.
" copy to attached terminal using the yank(1) script:
" https://github.com/sunaku/home/blob/master/bin/yank
function! Yank(text) abort
  let escape = system('yank', a:text)
  if v:shell_error
    echoerr escape
  else
    call writefile([escape], '/dev/tty', 'b')
  endif
endfunction
noremap <silent> <Leader>y y:<C-U>call Yank(@0)<CR>

" automatically run yank(1) whenever yanking in Vim
" (this snippet was contributed by Larry Sanderson)
function! CopyYank() abort
  call Yank(join(v:event.regcontents, "\n"))
endfunction
autocmd TextYankPost * call CopyYank()
" }}}

" Custom commands
command JSrun execute '!node '.shellescape(@%, 1)<CR>

" Use true color in terminal.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"""
""" /VIM.Configs
"""

"""
""" Plugin.Configs
"""

call plug#begin("$HOME/.config/nvim/bundle")

"" {{{ Automatic closing of quotes, parenthesis etc.
Plug 'Raimondi/delimitMate'

"" }}}

"" {{{ Auto comment
Plug 'scrooloose/nerdcommenter' " autocomment

nmap <C-;> <Leader>ci " Uncomment
"" }}}

" -- Git related
"" {{{ git modification status (on numbers)
Plug 'airblade/vim-gitgutter'

let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_removed='◢'
let g:gitgutter_sign_removed_first_line='◥'
let g:gitgutter_sign_modified_removed='◢'
"let g:gitgutter_highlight_lines = 1
"" }}}

"" {{{ Git commands
Plug 'tpope/vim-fugitive'

" NOTE: Used in statusline below.
"" }}}

""" {{{ Agit (Currently disabled in favor of GV)
"Plug 'cohama/agit.vim'
""" }}}

"" {{{ Git commit browser (GV)
" NOTE: Depends on 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
"" }}}

" -- Auto Completion
""" {{{ Advanced Autocompletion for multiple langs
""Plug 'Valloric/YouCompleteMe'
""" }}}

""" {{{ Dark Power neo-completion
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " Dark Powered neo-completion

"let g:deoplete#enable_at_startup = 1
""" }}}

"" {{{ Conquer of Completion
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

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
"" }}}

"" {{{
" coc-clangd + vim-lsp-cxx-highligh will give
" better semantic Highlightings for C & C++.
Plug 'jackguo380/vim-lsp-cxx-highlight'
"" }}}

" -- Linter
"" {{{ Syntax validation Syntactic. (Disabled in favor of ALE)
"Plug 'scrooloose/syntastic' " Syntax check with lots of validators
"" }}}

"" {{{ ALE - syntax check with lots of validators
Plug 'w0rp/ale'

" Configs->ALE
let g:ale_lint_on_text_changed = 'normal'
let g:ale_linters = {
\   'typescript': ['tslint'],
\   'javascript': ['eslint', 'tsserver'],
\   'go': [ 'golint', 'govet', 'gometalinter', 'gosimple', 'staticheck' ],
\   'c': [  ]
\}

let g:ale_fixers = {
\   'typescript': ['tslint']
\}
"" }}}

" -- Syntax highlighting.
Plug 'morhetz/gruvbox' " Dark/Light gruvbox
"Plug 'arcticicestudio/nord-vim'
Plug 'joshdick/onedark.vim'

"" {{{ Javascript
Plug 'pangloss/vim-javascript'

let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 0
let g:javascript_plugin_flow = 1
"" }}}

"" {{{ Markdown
Plug 'plasticboy/vim-markdown'

au FileType markdown set nofoldenable
au FileType markdown set wrap
au FileType markdown highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au FileType markdown match OverLength /\%81v.\+/
"" }}}

"" {{{ Others syntax highlighings
Plug 'isRuslan/vim-es6'             " es6 syntax
Plug 'HerringtonDarkholme/yats.vim' " typescript syntax
Plug 'tikhomirov/vim-glsl'          " Shaders
Plug 'GutenYe/json5.vim'            " JSON with comments highlight
"Plug 'tomlion/vim-solidity'         " Wanna eth?
"" }}}

" -- Tools
"" {{{ Quick scope - highligh characters when pressing `f, F, t`
Plug 'unblevable/quick-scope'        " Highlight characters when pressing `f, F, t`
"
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
"" }}}

"" {{{ Tabular - Align text with symbols
Plug 'godlygeek/tabular'             " Helps with alignments (E.g. this comments)
"" }}}

"" {{{ Undo Tree viewer (easy navigation in UNDO/REDO trees)
" NOTE: Rarely used.
Plug 'mbbill/undotree'
"" }}}

"" {{{ resize windows quickly. (<leader>e)
Plug 'simeji/winresizer'             " Resize windows quickly <leader>e

let g:winresizer_start_key = "<leader>e"
let g:winresizer_vert_size = 5
"" }}}

"" {{{ Multiple cursors (sometimes useful)
Plug 'terryma/vim-multiple-cursors'
"
" Config
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
"" }}}

"" {{{ Ack/Ag
" NOTE: Recommended to install the_silver_search in the system.
Plug 'mileszs/ack.vim'

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
"" }}}

"" {{{ vim-template - Custom template for languages (on empty file)
"Plug 'aperezdc/vim-template'         " Custom templates for languages (on empty files.)
"let g:templates_directory='~/.config/nvim/templates/'
"" }}}

"" {{{ wim-choosewin - Select window across tabs
Plug 't9md/vim-choosewin'

nmap  -  <Plug>(choosewin)
let g:choosewin_overlay_enable = 1
"" }}}

"" {{{ Minor utility plugins - without configs
Plug 'tpope/vim-surround'            " Auto Surrounding some stuff
Plug 'Mizuchi/vim-ranger'            " Opens file explorer in ranger cli tool
Plug 'majutsushi/tagbar'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/rfc-syntax'
"" }}}

"" {{{ FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

map <silent> <leader>lb :Buffers<CR>
map <silent> <leader>lf :GFiles<CR>
map <silent> <leader>lF :Files<CR>
nmap <silent> <leader>lw :Windows<CR>
nmap <silent> <leader>lg :GFiles?<CR>
"" }}}

"" {{{ Statusline with plugin data
function! SL(function)
  if exists('*'.a:function)
    return call(a:function,[])
  else
    return ''
  endif
endfunction

" Uses Fugitive and Syntastic
" TODO: Remove syntastic.
set statusline+=[%n]\ %<%.99f\ %h%w%m%r%{SL('CapsLockStatusline')}%y%{SL('fugitive#statusline')}%#ErrorMsg#%{SL('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P
"" }}}

"" {{{
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

"let g:pandoc#folding#fold_yaml = 1
"let g:pandoc#folding#fold_fenced_codeblocks = 1
"let g:pandoc#filetypes#handled = ['markdown']
"let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#folding#mode = 'stacked'
let g:pandoc#modules#enabled = ['folding', 'command']
"let g:pandoc#formatting#mode = 'h'
"" }}}

"" {{{ Vimwiki
Plug 'vimwiki/vimwiki'

let default_wiki = {}
let default_wiki.path = '~/dev/workspace/wiki-notes'
let default_wiki.path_html = '~/.tmp/nodwiki'
let default_wiki.syntax = 'markdown'
let default_wiki.ext = '.md'
let default_wiki.custom_wiki2html = 'pandoc'

let g:vimwiki_list = [default_wiki]
let g:vimwiki_filetypes = ['markdown']
let g:vimwiki_folding = 'custom'

"let g:vimwiki_ext2syntax = {'.md': 'markdown'}
"let g:vimwiki_global_ext = 0

au FileType vimwiki set filetype=markdown.pandoc
"" }}}
