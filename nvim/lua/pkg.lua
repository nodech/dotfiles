local nod = require('nod');
local pkg = {}

pkg.list = {
  -- Libs
  plenary = { p = 'nvim-lua/plenary.nvim' },
  --
  delimitmate = { p = 'Raimondi/delimitMate' },
  nerdcommenter = {
    -- Comement/Uncomment
    p = 'scrooloose/nerdcommenter',
    cmd = 'let g:NERDSpaceDelims = 1',
  },
  gitgutter = {
    -- Git modification status
    p = 'airblade/vim-gitgutter',
    cmd = [[
      let g:gitgutter_sign_added='┃'
      let g:gitgutter_sign_modified='┃'
      let g:gitgutter_sign_removed='◢'
      let g:gitgutter_sign_removed_first_line='◥'
      let g:gitgutter_sign_modified_removed='◢'
    ]],
    keymap = {
      n = {
        { k = ']h', a = '<Plug>(GitGutterNextHunk)' },
        { k = '[h', a = '<Plug>(GitGutterPrevHunk)' },
      },
    },
  },
  fugitive = { p = 'tpope/vim-fugitive', },
  gbrowse = { p = 'tpope/vim-rhubarb' },
  gvvim = { p = 'junegunn/gv.vim' }, -- Depends on 'tpope/vim-fugitive'
  coc = {
    p = 'neoclide/coc.nvim',
    br = 'release',
    run = function(plugin)
      vim.loop.spawn('yarn', {
        args = {'install'},
        cwd = plugin.dir,
      })
    end,
    cmd = [[
      function! CocShowDocumentation()
        if &filetype == 'vim'
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction
    ]],
    keymap = {
      n = {
        { k = '[d', a = '<Plug>(coc-diagnostic-prev)' },
        { k = ']d', a = '<Plug>(coc-diagnostic-next)' },

        { k = '[c', a = ':CocPrev<CR>' },
        { k = ']c', a = ':CocNext<CR>' },

        { k = 'gd', a = '<Plug>(coc-definition)' },
        { k = 'gy', a = '<Plug>(coc-type-definition)' },
        { k = 'gi', a = '<Plug>(coc-implementation)' },
        { k = 'gr', a = '<Plug>(coc-references)' },

        { k = 'K', a = ':call CocShowDocumentation()<CR>' },

        { k = '<leader>rn', a = '<Plug>(coc-rename)' },
        { k = '<leader>lc', a = ':CocList<CR>' },

        { k = '<leader>f', a = '<Plug>(coc-format-selected)' },

        { k = '<leader>th', a = ':CocCommand document.toggleInlayHint<CR>' },
      },
      v = {
        { k = '<leader>f', a = '<Plug>(coc-format-selected)' },
      },
    },
    aucmds = {
      { e = 'CursorHold', cmd = ":call CocActionAsync('highlight')" },
      -- { e = 'InsertEnter', cmd = ':CocCommand document.disableInlayHint' },
      -- { e = 'InsertLeave', cmd = ':CocCommand document.enableInlayHint' },
    }
  },
  -- cxx_highlight = {
  --   -- coc-clangd + vim-lsp-cxx-highligh will give
  --   -- better semantic Highlightings for C & C++.
  --   p = 'jackguo380/vim-lsp-cxx-highlight',
  --   cmd = 'let g:coc_default_semantic_highlight_groups = 1',
  -- },
  -- lspstatus = {
  --   p = 'nvim-lua/lsp-status.nvim'
  -- },
  ale = {
    p = 'w0rp/ale',
    cmd = [[
      let g:ale_lint_on_text_changed = 'normal'
      let g:ale_linters = {
      \   'typescript': ['tslint'],
      \   'javascript': ['eslint', 'tsserver'],
      \   'go': [ 'golint', 'govet', 'gometalinter', 'gosimple', 'staticheck' ],
      \   'c': [ ],
      \   'rust': [ 'cargo' ]
      \}
      " \   'rust': [ 'cargo' ]

      let g:ale_rust_cargo_use_clippy = 1

      let g:ale_fixers = {
      \   'typescript': ['tslint']
      \}
      let g:ale_sign_column_always = 1
      let g:ale_sign_error = '>>'
      let g:ale_sign_warning = '--'

      let g:ale_virtualtext_cursor = 2
      let g:ale_virtualtext_prefix = "\t\t\t>  "

      let g:ale_disable_lsp = 1
    ]],
    keymap = {
      n = {
        { k = '[l', a = '<Plug>(ale_previous_wrap)' },
        { k = ']l', a = '<Plug>(ale_next_wrap)' },
        { k = '[e', a = '<Plug>(ale_previous_wrap_error)' },
        { k = ']e', a = '<Plug>(ale_next_wrap_error)' }
      }
    }
  },
  -- vimjs = {
  --   p = 'pangloss/vim-javascript',
  --   cmd = [[
  --     let g:javascript_plugin_jsdoc = 1
  --     let g:javascript_plugin_ngdoc = 0
  --     let g:javascript_plugin_flow = 1
  --   ]]
  -- },
  -- vimmd = {
  --   p = 'plasticboy/vim-markdown',
  --   aucmds = {
  --     { e = 'FileType', p = 'markdown', cmd = 'set wrap'}
  --   },
  --   cmd = [[
  --     let g:vim_markdown_conceal = 0
  --   ]]
  -- },
  -- vimts = { p = 'HerringtonDarkholme/yats.vim' }, -- typescript syntax
  -- vimglsl = { p = 'tikhomirov/vim-glsl' },
  -- vimjson5 = { p = 'GutenYe/json5.vim' },
  qscope = {
    p = 'unblevable/quick-scope',
    cmd = "let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']",
  },
  tabular = { p = 'godlygeek/tabular' },
  undotree = { p = 'mbbill/undotree' },
  winresizer = {
    p = 'simeji/winresizer',
    cmd = [[
      let g:winresizer_start_key = "<leader>e"
      let g:winresizer_vert_size = 5
    ]]
  },
  multicursors = {
    p = 'terryma/vim-multiple-cursors',
    cmd = [[
      let g:multi_cursor_use_default_mapping   = 0
      let g:multi_cursor_exit_from_visual_mode = 0
      let g:multi_cursor_exit_from_insert_mode = 0

      let g:multi_cursor_start_word_key      = '<leader>mw'
      let g:multi_cursor_select_all_word_key = '<leader>ma'
      let g:multi_cursor_start_key           = 'g<leader>mw'
      let g:multi_cursor_select_all_key      = 'g<leader>ma'
      let g:multi_cursor_next_key            = '<C-n>'
      let g:multi_cursor_prev_key            = '<C-p>'
      let g:multi_cursor_skip_key            = '<C-x>'
      let g:multi_cursor_quit_key            = '<Esc>'
    ]]
  },
  surround = { p = 'tpope/vim-surround' },
  vista = {
    p = 'nodech/vista.vim',
    keymap = {
      n = {
        { k = '<leader>lv', a = ':Vista finder coc<CR>' },
        { k = '<F3>', a = ':Vista!!<CR>' }
      }
    }
  },
  editconf = { p = 'editorconfig/editorconfig-vim' },
  rfc = { p = 'vim-scripts/rfc-syntax' },

  fzf = {
    p = 'junegunn/fzf',
    run = './install --all && ln -s $(pwd) ~/.fzf'
  },
  fzfvim = {
    p = 'junegunn/fzf.vim',
    cmd = [[
      let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

      let g:fzf_vim = {}
      let g:fzf_vim.listproc = { list -> fzf#vim#listproc#quickfix(list) }

      command! -bang -nargs=? GFilesCwd
      \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == '?' ? { 'dir': getcwd(), 'placeholder': '' } : { 'dir': getcwd() }), <bang>0)
    ]],
    keymap = {
      n = {
        { k = '<leader>lb', a = ':Buffers<CR>' },
        { k = '<leader>lf', a = ':GFiles<CR>' },
        { k = '<leader>lF', a = ':GFilesCwd<CR>' },
        { k = '<leader>ll', a = ':Files<CR>' },
        { k = '<leader>lw', a = ':Windows<CR>' },
        { k = '<leader>lg', a = ':GFiles?<CR>' },
      }
    }
  },
  indentline = {
    p = 'Yggdroot/indentLine',
    cmd = [[
      let g:indentLine_setColors = 1
      let g:indentLine_char_list = ['|', '¦', '┆', '┊']
      let g:indentLine_concealcursor = 'inc'
      let g:indentLine_conceallevel = 2
      let g:vim_json_conceal = 0
      let g:vim_markdown_conceal = 0
      let g:vim_json_syntax_conceal = 0
      let g:vim_markdown_conceal = 0
      let g:vim_markdown_conceal_code_blocks = 0
    ]]
  },
  vimgo = {
    p = 'fatih/vim-go',
    cmd = [[
      let g:go_code_completion_enabled = 0
      let g:go_def_mapping_enabled = 0     " Disable gd
      let g:go_doc_keywordprg_enabled = 0  " Disable K
      let g:go_gopls_enabled = 0
    ]],
  },
  vimtpl = {
    p = 'aperezdc/vim-template',
    cmd = [[
      let g:templates_directory = '~/.config/nvim/templates'
    ]]
  },
  treesitter = {
    p = 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  },
  treesitterContext = {
    p = 'nvim-treesitter/nvim-treesitter-context',
    keymap = {
      n = {
        { k = '<F5>', a = ':TSContextToggle<CR>'}
      },
    },
  },

  treesitterTextObjects = {
    p = 'nvim-treesitter/nvim-treesitter-textobjects',
  },
  svelte = {
    p = 'leafOfTree/vim-svelte-plugin',
    cmd = [[
      let g:vim_svelte_plugin_use_typescript=1
    ]]
  },
  -- Library for the async IO
  nio = {
    p = 'nvim-neotest/nvim-nio'
  },
  dap = {
    p = 'mfussenegger/nvim-dap',
    keymap = {
      n = {
        { k = '<leader>db', a = function () require('dap').toggle_breakpoint() end },
        { k = '<leader>dR', a = function () require('dap').run_last() end},
        { k = '<leader>dr', a = ':DapContinue<CR>' },
        { k = '<leader>dt', a = ':DapTerminate<CR>' },
        { k = '<F9>', a = ':DapContinue<CR>' },
        { k = '<F10>', a = ':DapStepOver<CR>' },
        { k = '<F11>', a = ':DapStepInto<CR>' },
        { k = '<S-F11>', a = ':DapStepOut<CR>' },
      }
    },
  },
  dapUI = {
    p = 'rcarriga/nvim-dap-ui',
    keymap = {
      n = {
        { k = '<leader>dc', a = function() require('dapui').close() end },
        { k = '<leader>do', a = function() require('dapui').open() end },
        { k = '<leader>K', a = function() require('dap.ui.widgets').hover() end },
        { k = '<leader>ww', a = function() require('dapui').float_element('watches', { enter = true }) end },
        { k = '<leader>wc', a = function() require('dapui').float_element('scopes', { enter = true }) end },
        { k = '<leader>ws', a = function() require('dapui').float_element('stacks', { enter = true }) end },
        { k = '<leader>wb', a = function() require('dapui').float_element('breakpoints', { enter = true}) end },
        { k = '<leader>wr', a = function() require('dapui').float_element('repl', { enter = true }) end },
      }
    },
  },
  dapVirt = {
    p = 'theHamsta/nvim-dap-virtual-text',
  },
  -- ranger = { p = 'Mizuchi/vim-ranger' },
  devicons = {
    p = 'nvim-tree/nvim-web-devicons'
  },
  oil = {
    p = 'stevearc/oil.nvim',
  },
  -- nui = {
  --   p = 'MunifTanjim/nui.nvim',
  -- },
  -- hardtime = {
  --   p = 'm4xshen/hardtime.nvim'
  -- },
  ppd = {
    p = "nodech/ppd.nvim",

  },
}

local pkgKeys = {}

for name, _ in pairs(pkg.list) do
  table.insert(pkgKeys, name)
end

pkg.prepare = function()
  for name, pkg in pairs(pkg.list) do
    if pkg.aucmds ~= nil then
      nod.commands['pkg_' .. name] = pkg.aucmds
    end

    if pkg.cmd ~= nil then
      vim.cmd(pkg.cmd)
    end

    if pkg.keymap ~= nil then
      nod.merge_map_keys(pkg.keymap)
    end
  end

  vim.api.nvim_create_user_command('NodPkgMappings', function (opts)
    local name = opts.fargs[1]
    local keymap = pkg.listKeymap(name)

    if keymap == nil then
      print('Keymap not found for ' .. name)
      return
    end

    print('Keymap for ' .. name)
    put(keymap)

  end, {
    nargs = 1,
    complete = function (arglead, cmdLine, cursorPos)
      local matches = {}

      for _, item in ipairs(pkgKeys) do
        if item:sub(1, #arglead) == arglead then
          table.insert(matches, item)
        end
      end

      return matches
    end
  })
end

pkg.listKeymap = function (name)
  if pkg.list[name] == nil or pkg.list[name].keymap == nil then
    return nil
  end

  return pkg.list[name].keymap
end

pkg.setup = function(packager)
  for name, pkg in pairs(pkg.list) do
    local options = nil

    if pkg.run then
      options = {
        ['do'] = pkg.run
      }
    end

    if pkg.br then
      options = options or {}
      options.branch = pkg.br
    end

    if options ~= nil then
      packager.add(pkg.p, options)
    else
      packager.add(pkg.p)
    end
  end
end

return pkg
