local color = {
  plugin = 'nodech/catppuccin-nvim',
  colorscheme = 'catppuccin',
  setup = function ()
    require('catppuccin').setup {
      flavour = 'mocha'
    };
  end,
}

return color
