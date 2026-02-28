local color = {
  plugin = 'nodech/ayu-vim',
  cmd = 'let ayucolor="dark"',
  colorscheme = 'ayu',
  setup = function ()
    vim.o.background = 'dark';
  end
}

return color
