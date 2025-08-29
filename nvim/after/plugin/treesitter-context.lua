local ok, mod = pcall(require, 'treesitter-context')

if not ok then
  return
end

mod.setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  line_numbers = true,
  trim_scope = 'outer'
}
