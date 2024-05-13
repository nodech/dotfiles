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
set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#foldexpr()'

-- set.foldmethod = 'syntax' -- fold using expression
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
-- set.showtabline = 2       -- always on. (experiment with custom tabline)

set.wildignore = {
}

set.termguicolors = true  -- use terminal colors

vim.g.mapleader = ','

nod.keymaps = {
  -- normal mode
  n = {
    -- Clipboard switches, TODO: pastetoggle?
    { k = '<F2>', a = function()
      local current = set.clipboard:get()

      if #current == 0 then
        set.clipboard = 'unnamedplus'
        print('clipboard=unnamedplus')
      else
        set.clipboard = ''
        print('clipboard=')
      end
    end },
    { k = '<F4>', a = function ()
      local copilot_enabled = vim.g.copilot_enabled

      if copilot_enabled == 1 or copilot_enabled == nil then
        vim.g.copilot_enabled = 0
        print('copilot disabled')
      else
        vim.g.copilot_enabled = 1
        print('copilot enabled')
      end
    end},

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

    -- buffer jumps
    { k = '[b', a = ':bprev<CR>' },
    { k = ']b', a = ':bnext<CR>' },

    -- quickfix list
    { k = '[q', a = ':cprev<CR>' },
    { k = ']q', a = ':cnext<CR>' },

    -- debug syntax
    {
      k = '<leader>zS',
      a = [[:echo join(reverse(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")')),' ')<CR>]]
    },
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
  highligh_yank = {
    { e = 'TextYankPost', cmd = 'silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=100})'}
  },

  -- err_80 = {
  --   { e = 'BufWinEnter', p = '*.c', cmd = "let w:m2=matchadd('ErrorMsg', '\\%>80v.\\+', -1)" },
  -- },
}

vim.cmd [[
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
]]

-- Some Vim helper functions
vim.cmd [[
fun! InspectSynHL()
    let l:synNames = []
    let l:idx = 0
    for id in synstack(v:beval_lnum, v:beval_col)
        call add(l:synNames, printf('%s%s', repeat(' ', idx), synIDattr(id, 'name')))
        let l:idx+=1
    endfor
    return join(l:synNames, "\n")
endfun

function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
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

_G.nodstatusline = statusline.statusline
set.statusline = "%{%v:lua.nodstatusline()%}"

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
