local HOME = os.getenv('HOME')

-- General configs
vim.opt.number = true         -- show numbers
vim.opt.rnu = true            -- show relative line numbers
vim.opt.complete = vim.opt.complete + 'k'  -- scan the files as well
vim.opt.wrap = false           -- don't wrap lines

vim.opt.listchars = {
  tab = '▸ ',
  eol = '¬',
  leadmultispace = "│ ",
} -- show tabs and end of line
vim.opt.list = true

vim.opt.shiftwidth = 2        -- indent 2 spaces
vim.opt.tabstop = 2           -- tabstop 2 spaces
vim.opt.expandtab = true      -- expand tabs to spaces

vim.opt.visualbell = true     -- visual bell
vim.opt.mouse = 'a'           -- mouse support

-- Fold Configs
vim.opt.foldenable = true     -- enable folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- vim.opt.foldmethod = 'syntax' -- fold using expression
vim.opt.foldlevelstart = 100  -- start fold level
vim.opt.foldnestmax = 7       -- fold nesters

-- Temp files
vim.opt.directory = HOME .. '/.config/nvim/tmp' -- temp files directory
vim.opt.writebackup = false   -- don't write backup files

vim.opt.autoread = false      -- don't auto read files
vim.opt.autowrite = false     -- don't auto write files
vim.opt.autowriteall = false  -- don't auto write all files

vim.opt.wildmenu = true       -- show wildmenu
vim.opt.wildmode = 'list:longest,full' -- wildmenu mode

vim.opt.cursorline = true     -- show cursor line
vim.opt.lazyredraw = true     -- lazy redraw

vim.opt.ignorecase = true     -- ignore case
vim.opt.smartcase = true      -- smart case

vim.opt.autoindent = true     -- auto indent
vim.opt.smartindent = true    -- smart indent
vim.opt.completeopt='menuone,menu,longest,preview'
-- vim.opt.showtabline = 2       -- always on. (experiment with custom tabline)

vim.opt.wildignore = {
}

vim.opt.termguicolors = true  -- use terminal colors

vim.opt.title = true          -- vim.opt.terminal title
vim.opt.titlestring='Nvim - %t%( %M%)%( (%{expand("%:~:h")})%)%a'

-- Save folds
vim.opt.viewoptions = "folds"

-- Diff view fill chars
vim.opt.fillchars:append({ diff = " " })

vim.g.mapleader = ','
