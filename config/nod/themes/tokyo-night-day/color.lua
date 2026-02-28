local color = {
  plugin = 'folke/tokyonight.nvim',
  colorscheme = 'tokyonight-day',
  setup = function ()
    vim.o.background = 'light';
    require('tokyonight').setup {
      style = 'day'
    }
  end
}

return color
