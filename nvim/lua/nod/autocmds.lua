local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group_rnu = augroup('nod_rnu', { clear = true })

-- On relative numbers toggle
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

-- highlight copied text.
local highlight_yank = augroup('nod_highlight_yank', { clear = true })

autocmd('TextYankPost', {
  group = highlight_yank,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

-- Save/restore view
local view_update = augroup('nod_view_update', { clear = true })
autocmd('BufWinEnter', {
  group = view_update,
  pattern = '*',
  command = 'silent! loadview',
})

autocmd('BufWinLeave', {
  group = view_update,
  pattern = '*',
  command = 'silent! mkview',
})
