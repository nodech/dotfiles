require('globals')
require('nod.options')
require('nod.plugins')
require('nod.keymaps')
require('nod.autocmds')
require('nod.lsp')

-- setup nodstatusline
local statusline = require('nod.statusline')
_G.nodstatusline = statusline.statusline
vim.opt.statusline = '%{%v:lua.nodstatusline()%}'

-- Load color.lua - dynamic theme if available.
local ok, color = pcall(require, 'color')
if ok and color.plugin then
  vim.pack.add({
    { src = 'https://github.com/' .. color.plugin },
  })

  if color.cmd then
    vim.cmd(color.cmd)
  end

  if color.setup then
    color.setup()
  end

  if color.colorscheme then
    vim.cmd('colorscheme ' .. color.colorscheme)
  end
end
