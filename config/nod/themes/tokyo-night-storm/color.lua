local color = {
  plugin = 'nodech/tokyonight.nvim',
  colorscheme = 'tokyonight-storm',
  setup = function ()
    vim.o.background = 'dark';
    require('tokyonight').setup {
      style = 'storm'
    }
  end
}

return color
