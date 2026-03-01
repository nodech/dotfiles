local color = {
  plugin = 'nodech/ayu-vim',
  cmd = 'let ayucolor="mirage"',
  colorscheme = 'ayu',
  setup = function ()
    vim.o.background = 'dark';
  end
}


return color
