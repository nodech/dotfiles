--- @type vim.lsp.Config
return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = {
    'bash',
    'c',
    'cpp',
    'cs',
    'dockerfile',
    'gitcommit',
    'go',
    'html',
    'javascript',
    'lua',
    'markdown',
    'python',
    'rust',
    'toml',
    'typescript',
    'cmake',
    'sh',
  },
  root_markers = { '.git' },
  settings = {
    ['harper-ls'] = {
      linters = {
        ExpandMemoryShorthands = false,
      },
    },
  },
}
