local ok, mod = pcall(require, 'treesitter-context')

if not ok then
  vim.notify('Failed to load treesitter-context', vim.log.levels.WARN)
  return
end

mod.setup {
  enable = true,
  line_numbers = true,
  trim_scope = 'outer'
}
