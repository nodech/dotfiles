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
