-- Nod vim init.

require('globals')
local statusline = require('statusline')
local nod = require('nod')
local pkg = require('pkg')
local color = require('color')
local HOME = os.getenv("HOME")
local set = vim.opt

-- Do all vim configs

-- General configs
set.number = true         -- show numbers
set.rnu = true            -- show relative line numbers
set.complete = set.complete + 'k'  -- scan the files as well
set.wrap = false           -- don't wrap lines
set.popt = 'left:8pc,right:3pc'

set.listchars = {
  tab = '▸ ',
  eol = '¬',
} -- show tabs and end of line
set.list = true

set.shiftwidth = 2        -- indent 2 spaces
set.tabstop = 2           -- tabstop 2 spaces
set.expandtab = true      -- expand tabs to spaces

set.visualbell = true     -- visual bell
set.pastetoggle = '<F2>'  -- paste toggle
set.mouse = 'a'           -- mouse support

-- Fold Configs
set.foldenable = true     -- enable folding
set.foldmethod = 'syntax' -- fold using expression
set.foldlevelstart = 100  -- start fold level
set.foldnestmax = 7       -- fold nesters

-- Temp files
set.directory = HOME .. '/.config/nvim/tmp' -- temp files directory
set.writebackup = false   -- don't write backup files

set.autoread = false      -- don't auto read files
set.autowrite = false     -- don't auto write files
set.autowriteall = false  -- don't auto write all files

set.wildmenu = true       -- show wildmenu
set.wildmode = 'list:longest,full' -- wildmenu mode

set.cursorline = true     -- show cursor line
set.lazyredraw = true     -- lazy redraw

set.ignorecase = true     -- ignore case
set.smartcase = true      -- smart case

set.autoindent = true     -- auto indent
set.smartindent = true    -- smart indent
set.completeopt='menuone,menu,longest,preview'

set.wildignore = {
  'tags',
  'tmp/**',
  'node_modules/**',
}

set.termguicolors = true  -- use terminal colors

vim.g.mapleader = ','

nod.keymaps = {
  -- normal mode
  n = {
    -- Clipboard switches, TODO: pastetoggle?
    { k = '<C-c>', a = ':set clipboard=unnamedplus<CR>' },
    { k = '<C-x>', a = ':set clipboard=<CR>' },

    { k = '<C-L>', a = ':nohl<CR><C-L>' },
    { k = '<C-K>', a = ':set list!<CR>' },

    -- folds
    { k = '<leader>zc', a = ':set foldlevel=1<CR>' },
    { k = '<leader>zo', a = ':set foldlevel=99<CR>' },
    { k = '<leader>zf', a = ':set foldlevel=', silent = false },

    -- tabs switches
    { k = '<C-N>', a = 'gt' },
    { k = '<C-P>', a = 'gT' },
    { k = '<leader>tn', a = 'tabmove +1<CR>' },
    { k = '<leader>tp', a = 'tabmove -1<CR>' },
  },

  -- visual mode
  v = {
    { k = '.', a = ':norm.<CR>' },

    -- move lines left and right
    { k = '>', a = '> gv' },
    { k = '<', a = '< gv' },

    -- move lines up and down
    { k = 'K', a = ':m -2<CR> gv' },
    { k = 'J', a = ':m +1<CR> gv' },
  },

  x = {
    -- remap paste that keeps the clipboard
    { k = '<leader>p', a = '"_dP' },
  },

  -- terminal
  t = {
    { k = '<C-]>', a = '<c-\\><c-n>' },
  },
}

nod.commands = {
  view_update = {
    { e = 'BufWinEnter', cmd = 'silent! loadview' },
    { e = 'BufWinLeave', cmd = 'silent! mkview' },
  },
  rnu = {
    { e = {'FocusLost', 'InsertEnter'}, cmd = 'set rnu!' },
    { e = {'FocusGained', 'InsertLeave'}, cmd = 'set rnu' },
  },

  -- err_80 = {
  --   { e = 'BufWinEnter', p = '*.c', cmd = "let w:m2=matchadd('ErrorMsg', '\\%>80v.\\+', -1)" },
  -- },
}

vim.cmd [[
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
]]

-- Setup pkg
if color.plugin then
  pkg.list.color = { p = color.plugin }
end

-- Setup auto commands and keymaps for all the deps
pkg.prepare()

-- Setup auto commands for the statusline
statusline.commands()

-- Register all keymaps
nod.map_keys()

-- Register all autocommands
nod.register_aucmds()

_G.statusline = statusline.statusline
set.statusline = "%{%v:lua.statusline(bufnr('%'))%}"

-- Setup packages
vim.cmd [[packadd vim-packager]]
require('packager').setup(pkg.setup)

vim.cmd[[
  filetype plugin indent on
  syntax on
  hi Normal guibg=NONE ctermbg=NONE

  autocmd! BufRead,BufNewFile *.h,*.c set filetype=c
]]

if color.cmd then
  vim.cmd(color.cmd)
end

if color.colorscheme then
  vim.cmd('colorscheme ' .. color.colorscheme)
end
