local gh = function(x)
  return 'https://github.com/' .. x
end

local plugins = {
  -- General
  { gh('nodech/nvim-web-devicons') }, -- { gh('nvim-tree/nvim-web-devicons') },

  -- fzf fuzzy finder.
  {
    gh('nodech/fzf.vim'), -- gh('junegunn/fzf.vim'),
    config = 'nod.plugins.fzf',
  },

  -- Treesitter
  {
    gh('nvim-treesitter/nvim-treesitter'),
    hook = function()
      vim.cmd('TSUpdate')
    end,
    config = 'nod.plugins.treesitter',
  },
  {
    gh('nvim-treesitter/nvim-treesitter-context'),
    config = 'nod.plugins.treesitter-context',
  },
  {
    {
      src = gh('nvim-treesitter/nvim-treesitter-textobjects'),
      version = 'main',
    },
    config = 'nod.plugins.treesitter-textobjects',
  },

  -- Completion and related
  {
    gh('nodech/blink.cmp'), -- gh('saghen/blink.cmp'),
    config = 'nod.plugins.blink',
  },
  {
    gh('nodech/vista.vim'),
    config_fn = function()
      vim.keymap.set('n', '<leader>lv', ':Vista finder vim_lsp<CR>')
      vim.keymap.set('n', '<F3>', ':Vista!!<CR>')
    end,
  },

  -- Git related
  { gh('nodech/vim-fugitive') }, -- { gh('tpope/fugitive') },

  {
    gh('nodech/gitsigns.nvim'), -- { gh('lewis6991/gitsigns') }
    config = 'nod.plugins.gitsigns',
  },

  -- File utilities
  {
    gh('nodech/oil.nvim'),
    config_fn = function()
      require('oil').setup {
        delete_to_trash = true,

        columns = {
          'icon',
          -- "permissions",
          -- "size",
          -- "mtime",
        },

        view_options = {
          show_hidden = true,
        },
      }
    end,
  }, -- { gh('stevearc/oil.nvim') },
  {
    gh('nodech/ppd.nvim'),
    config_fn = function()
      local ppd = require('ppd')
      ppd.setup({
        -- Automatically push paths from DirChanged events onto the stack
        auto_cd = true,
        dedup = {
          -- Do not push a path that is the same as the newest path on the stack
          top = true,
          -- Do not push any duplicates onto the stack
          all = false,
        },
        notify = {
          -- Display the stack on all pushd invocations
          on_pushd = true,
          -- Display the stack on all popd invocations
          on_popd = true,
        },
      })
    end,
  }, -- { gh('PriceHiller/ppd.nvim')}

  -- Edit utilities
  { gh('nodech/vim-surround') }, -- tpope
  { gh('nodech/vim-visual-multi') }, -- mg979
  {
    gh('nodech/quick-scope'),
    config_fn = function ()
      vim.cmd [[
        let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
      ]]
    end
  }, -- unblevable

  -- Windows
  {
    gh('nodech/winresizer'),
    config_fn = function()
      vim.cmd [[
        let g:winresizer_start_key = '<leader>e'
        let g:winresizer_vert_size = 5
      ]]
    end,
  }, -- simeji
}

local plug2hook = {}

local load_list = vim
  .iter(plugins)
  :map(function(x)
    -- index post install/update hooks
    if x.hook then
      plug2hook[x[1]] = x.hook
    end

    return x.src or x[1]
  end)
  :totable()

local hook = function(ev)
  if plug2hook[ev.data.spec.src] then
    vim.cmd.packadd(ev.data.spec.name)
    plug2hook[ev.data.spec.src]()
  end
end

local update_group = vim.api.nvim_create_augroup('nod_packs', { clear = true })
vim.api.nvim_create_autocmd('PackChanged', {
  group = update_group,
  callback = hook,
})

vim.pack.add(load_list)

for _, mod in ipairs(plugins) do
  if mod.config then
    local success, err = pcall(require, mod.config)

    if not success then
      vim.notify('Failed to load ' .. mod.config .. ': ' .. err, vim.log.levels.WARN)
    end
  end

  if mod.config_fn then
    mod.config_fn()
  end
end
