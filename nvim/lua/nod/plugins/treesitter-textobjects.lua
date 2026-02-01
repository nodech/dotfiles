local ok, mod = pcall(require, 'nvim-treesitter-textobjects')

if not ok then
  vim.notify('Failed to load nvim-treesitter-textobjects', vim.log.levels.WARN)
  return
end

mod.setup {
  select = {
    lookahead = true,

    include_surrounding_whitespace = false,

    selection_modes = {
      ['@parameter.outer'] = 'v',
      ['@function.outer'] = 'V',
    }
  },
}

local select = require 'nvim-treesitter-textobjects.select'

local selmap = function(key, obj, query_group)
  query_group = query_group or "textobjects"

  vim.keymap.set({ "x", "o" }, key, function ()
    select.select_textobject(obj, query_group)
  end)
end

-- selects
selmap("af", "@function.outer")
selmap("if", "@function.inner")

selmap("aa", "@parameter.outer")
selmap("ia", "@parameter.inner")

-- swaps
local swap = require 'nvim-treesitter-textobjects.swap'

vim.keymap.set("n", "<leader>a", function()
  swap.swap_next "@parameter.inner"
end)

vim.keymap.set("n", "<leader>A", function()
  swap.swap_previous "@parameter.inner"
end)

-- moves
local move = require 'nvim-treesitter-textobjects.move'

vim.keymap.set({ "n", "x", "o" }, "]a", function ()
  move.goto_next_start("@parameter.inner", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "[a", function ()
  move.goto_previous_start("@parameter.inner", "textobjects")
end)
