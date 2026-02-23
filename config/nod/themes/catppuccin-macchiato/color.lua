local color = {
  plugin = 'catppuccin/nvim',
  colorscheme = 'catppuccin',
  setup = function ()
    require('catppuccin').setup({
      flavour = 'macchiato'
    })
  end
}

return color
