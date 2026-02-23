local augroup = vim.api.nvim_create_augroup

local blink = require 'blink.cmp'

local languages = {
  {
    name = 'rust_analyzer',
    config = require 'nod.lsp.rust_analyzer',
    merge_blink = true,
  },
  {
    name = 'harper_ls',
    config = require 'nod.lsp.harper_ls',
  },
  {
    name = 'lua_ls',
    config = require 'nod.lsp.lua_ls',
    merge_blink = true,
  },
  {
    name = 'stylua',
    config = require 'nod.lsp.stylua',
  },
  {
    name = 'ts_ls',
    config = require 'nod.lsp.ts_ls',
  },
}

for _, lang in pairs(languages) do
  local config = lang.config

  if lang.merge_blink then
    config.capabilities = blink.get_lsp_capabilities(config.capabilities)
  end

  vim.lsp.config(lang.name, config)
end

vim.lsp.enable(vim
  .iter(languages)
  :map(function(x)
    return x.name
  end)
  :totable())

-- Couple custom lsp things.
local lsp_group = augroup('nod_lsp', {})
local lsp_detach_group = augroup('lsp-detach', { clear = true })

local lsp_callback = function(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = ev.buf
    vim.keymap.set(mode, l, r, opts)
  end

  if client and client:supports_method('textDocument/inlayHint', ev.buf) then
    -- Toggle inlay hints.
    map('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf })
    end)
  end

  if client and client:supports_method('textDocument/documentHighlight', ev.buf) then
    map('n', 'gh', vim.lsp.buf.document_highlight)
    map('n', 'gH', vim.lsp.buf.clear_references)

    vim.api.nvim_create_autocmd('LspDetach', {
      group = lsp_detach_group,
      callback = vim.lsp.buf.clear_references,
      buffer = ev.buf,
    })
  end

  -- Formatters
  if client and client:supports_method('textDocument/formatting', ev.buf) then
    -- NOTE: If multiple LSPs with formatting attach, may need to FIX this.
    map('n', '<leader>ff', function()
      vim.lsp.buf.format({ bufnr = ev.buf })
    end)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = lsp_callback,
})

-- Diagnostics Keymaps
local map = vim.keymap.set

vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR
  },
  -- virtual_lines = {
  --   severity = vim.diagnostic.severity.ERROR
  -- },
  float = {
    border = 'rounded',
    source = true,
  },
})

-- Toggle active diagnostics texts.
map('n', '<leader>tdd', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)

map('n', '<leader>tdl', function ()
  vim.diagnostic.config({
    virtual_lines = not vim.diagnostic.config().virtual_lines,
  })
end)

map('n', '<leader>tdt', function ()
  vim.diagnostic.config({
    virtual_text = not vim.diagnostic.config().virtual_text,
  })
end)

-- Errors only (rust-analyzer in practice)
map('n', '[e', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end)

map('n', ']e', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end)

map('n', 'gl', vim.diagnostic.open_float)
map('n', '<leader>dq', vim.diagnostic.setloclist)
map('n', '<leader>dQ', vim.diagnostic.setqflist)
