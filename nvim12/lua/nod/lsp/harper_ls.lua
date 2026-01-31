--- @type vim.lsp.Config
return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = { '*' },
  root_markers = { '.git' },
  settings = {
    ['harper-ls'] = {
      linters = {
        ExpandMemoryShorthands = false,
      },
    },
  },
}
