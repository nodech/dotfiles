local nod = require('nod');
local pkg = {}

pkg.list = {
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
        { k = '[c', a = '<Plug>(coc-diagnostic-prev)' },
        { k = ']c', a = '<Plug>(coc-diagnostic-next)' },

        { k = 'gd', a = '<Plug>(coc-definition)' },
        { k = 'gy', a = '<Plug>(coc-type-definition)' },
        { k = 'gi', a = '<Plug>(coc-implementation)' },
        { k = 'gr', a = '<Plug>(coc-references)' },

        { k = 'K', a = ':call CocShowDocumentation()<CR>' },

        { k = '<leader>rn', a = '<Plug>(coc-rename)' },
        { k = '<leader>lc', a = 'CocList<CR>' },

        { k = '<leader>f', a = '<Plug>(coc-format-selected)' }
      },
      v = {
        { k = '<leader>f', a = '<Plug>(coc-format-selected)' },
      },
    },
    aucmds = {
      { e = 'CursorHold', cmd = ":call CocActionAsync('highlight')" },
    }
  },
  cxx_highlight = {
    -- coc-clangd + vim-lsp-cxx-highligh will give
    -- better semantic Highlightings for C & C++.
    p = 'jackguo380/vim-lsp-cxx-highlight',
    cmd = 'let g:coc_default_semantic_highlight_groups = 1',
  },
  lspstatus = {
    p = 'nvim-lua/lsp-status.nvim'
  },
  ale = {
    p = 'w0rp/ale',
    cmd = [[
      let g:ale_lint_on_text_changed = 'normal'
      let g:ale_linters = {
      \   'typescript': ['tslint'],
      \   'javascript': ['eslint', 'tsserver'],
      \   'go': [ 'golint', 'govet', 'gometalinter', 'gosimple', 'staticheck' ],
      \   'c': [ ]
      \}

      let g:ale_fixers = {
      \   'typescript': ['tslint']
      \}
    ]],
    keymap = {
      n = {
        { k = '[l', a = '<Plug>(ale_previous_wrap)' },
        { k = ']l', a = '<Plug>(ale_next_wrap)' }
      }
    }
  },
  vimjs = {
    p = 'pangloss/vim-javascript',
    cmd = [[
      let g:javascript_plugin_jsdoc = 1
      let g:javascript_plugin_ngdoc = 0
      let g:javascript_plugin_flow = 1
    ]]
  },
  vimmd = {
    p = 'plasticboy/vim-markdown',
    aucmds = {
      { e = 'FileType', p = 'markdown', cmd = 'set wrap'}
    }
  },
  vimes6 = { p = 'isRuslan/vim-es6' },
  vimts = { p = 'HerringtonDarkholme/yats.vim' }, -- typescript syntax
  vimglsl = { p = 'tikhomirov/vim-glsl' },
  vimjson5 = { p = 'GutenYe/json5.vim' },
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
  ack = {
    p = 'mileszs/ack.vim',
    cmd = "let g:ackprg = 'arg --vimpgrep'"
  },
  choosewin = {
    p = 't9md/vim-choosewin',
    cmd = 'let g:choosewin_overlay_enable = 1',
    keymap = {
      n = {
        { k = '-', a = '<Plug>(choosewin)' }
      }
    }
  },
  surround = { p = 'tpope/vim-surround' },
  ranger = { p = 'Mizuchi/vim-ranger' },
  vista = { p = 'liuchengxu/vista.vim' },
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
    ]],
    keymap = {
      n = {
        { k = '<leader>lb', a = ':Buffers<CR>' },
        { k = '<leader>lf', a = ':GFiles<CR>' },
        { k = '<leader>lF', a = ':Files<CR>' },
        { k = '<leader>lw', a = ':Windows<CR>' },
        { k = '<leader>lg', a = ':GFiles?<CR>' },
      }
    }
  },
  indentline = {
    p = 'Yggdroot/indentLine',
    cmd = [[
      let g:indentLine_setColors = 0
      let g:indentLine_char_list = ['|', '¦', '┆', '┊']
      let g:indentLine_concealcursor = 'inc'
      let g:indentLine_conceallevel = 2
    ]]
  },
  wakatime = { p = 'wakatime/vim-wakatime' },
}

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
