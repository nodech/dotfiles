local ok, mod = pcall(require, 'nvim-treesitter.configs')

if not ok then
  return
end

mod.setup {
  ensure_installed = {
    "c",
    "typescript",
    "javascript",
    "json",
    "json5",
    "jsdoc",
    "lua",
    "go",
  },

  auto_install = false,

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  highlight = {
    enable = true,

    disable = function(lang, buf)
      if lang == 'markdown' or lang == 'typescript' then
        return true
      end

      local max_filesize = 200 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  additional_vim_regex_highlighting = true,

  textobjects = {
    select = {
      enable = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        -- ["ac"] = "@class.outer",
        -- ["ic"] = "@class.inner",

        ["ic"] = "@conditional.inner",
        ["ac"] = "@conditional.outer",
      },
    },
  },
}
