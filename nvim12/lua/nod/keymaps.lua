local map = vim.keymap.set

-- Should clipboard be shared with the system.
-- Default true
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

map('n', '<F2>', function()
  local current = vim.opt.clipboard:get()

  if #current == 0 then
    vim.opt.clipboard = 'unnamedplus'
    print('clipboard=unnamedplus')
  else
    vim.opt.clipboard = ''
    print('clipboard=')
  end
end)

-- folds
map('n', '<leader>zc', ':set foldlevel=1<CR>')
map('n', '<leader>zo', ':set foldlevel=99<CR>')
map('n', '<leader>zf', ':set foldlevel=', { silent = false })

-- Focus / blur a buffer.
map('n', '<C-w>z', ':tab split<CR>')
map('n', '<C-w>Z', ':tab close<CR>')

-- Indent/Unindent quickly.
map('v', '.', ':norm.<CR>')

map('v', '>', '> gv')
map('v', '<', '< gv')

map('v', 'K', ':m -2<CR> gv')
map('v', 'J', ':m +1<CR> gv')

-- remap paste that keeps the clipboard
map('x', '<leader>p', '"_dP')

-- terminal simpler escape
map('t', '<C-]>', '<c-\\><c-n>')
