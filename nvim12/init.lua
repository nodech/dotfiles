require('globals')
require('nod.options')
require('nod.plugins')
require('nod.keymaps')
require('nod.autocmds')
require('nod.lsp')

-- Load color.lua - dynamic theme if available.
local ok, color = pcall(require, 'color');
if ok and color.plugin then
  vim.pack.add({
    { src = 'https://github.com/' .. color.plugin }
  })

  if color.cmd then
    vim.cmd(color.cmd)
  end

  if color.colorscheme then
    vim.cmd('colorscheme ' .. color.colorscheme)
  end
end
