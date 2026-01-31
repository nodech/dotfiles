local augroup = vim.api.nvim_create_augroup

local blink = require'blink.cmp'

local languages = {
  {
    name = 'rust_analyzer',
    config = require 'nod.lsp.rust_analyzer',
    merge_blink = true
  },
  { name = 'harper_ls', config = require 'nod.lsp.harper_ls' },
};

for _, lang in pairs(languages) do
  local config = lang.config

  if lang.merge_blink then
    config.capabilities = blink.get_lsp_capabilities(config.capabilities)
  end

  vim.lsp.config(lang.name, config)
end

vim.lsp.enable(vim.iter(languages)
  :map(function(x)
    return x.name
  end)
  :totable())

vim.diagnostic.config({
  virtual_text = true
})

-- Couple custom lsp things.
local lsp_group = augroup('nod_lsp', {});
local lsp_callback = function(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)

  if client and client:supports_method('textDocument/inlayHint', ev.buf) then
    vim.keymap.set('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf })
    end)
  end

  if client and client:supports_method('textDocument/documentHighlight', ev.buf) then
    local highlight_augroup = augroup('lsp-highlight', { clear = false })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = ev.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = ev.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
      end,
    })
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = lsp_callback
})
