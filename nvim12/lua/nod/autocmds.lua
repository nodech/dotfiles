local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group_rnu = augroup('nod_rnu', { clear = true })

autocmd({ 'FocusLost', 'InsertEnter' }, {
  group = group_rnu,
  pattern = '*',
  command = 'set rnu!',
})

autocmd({ 'FocusGained', 'InsertLeave' }, {
  group = group_rnu,
  pattern = '*',
  command = 'set rnu',
})

local highlight_yank = augroup('nod_highlight_yank', { clear = true })

autocmd('TextYankPost', {
  group = highlight_yank,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})
