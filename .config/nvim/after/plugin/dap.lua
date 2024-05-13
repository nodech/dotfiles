local ok, dap = pcall(require, 'dap')

if not ok then
  return
end

-- <leader>K hover
-- local api = vim.api
-- local keymap_restore = {}
-- dap.listeners.after['event_initialized']['me'] = function()
--   for _, buf in pairs(api.nvim_list_bufs()) do
--     local keymaps = api.nvim_buf_get_keymap(buf, 'n')
--     for _, keymap in pairs(keymaps) do
--       if keymap.lhs == "K" then
--         table.insert(keymap_restore, keymap)
--         api.nvim_buf_del_keymap(buf, 'n', 'K')
--       end
--     end
--   end
--   api.nvim_set_keymap(
--     'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
-- end

-- dap.listeners.after['event_terminated']['me'] = function()
--   for _, keymap in pairs(keymap_restore) do
--     api.nvim_buf_set_keymap(
--       keymap.buffer,
--       keymap.mode,
--       keymap.lhs,
--       keymap.rhs,
--       { silent = keymap.silent == 1 }
--     )
--   end
--   keymap_restore = {}
-- end

-- Virtual Text setup.
local okvui, dapvui = pcall(require, 'nvim-dap-virtual-text');

if okvui then
  dapvui.setup {
    commented = true
  }
end

-- DAPUI Stuff
local okui, dapui = pcall(require, 'dapui')

if okui then
  dapui.setup()

  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  -- Instead <leader>dc
  -- dap.listeners.before.event_terminated.dapui_config = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited.dapui_config = function()
  --   dapui.close()
  -- end
end
