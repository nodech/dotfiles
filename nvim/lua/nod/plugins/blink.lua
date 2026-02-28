local ok, mod = pcall(require, 'blink.cmp')

if not ok then
  vim.notify('Failed to load blink.cmp', vim.log.levels.WARN)
  return
end

mod.setup {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = {
    preset = 'super-tab',
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  -- (Default) Only show the documentation popup when manually triggered
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },

    ghost_text = {
      enabled = true,
    },

    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },

    accept = {
      auto_brackets = {
        enabled = false
      }
    },
  },

  -- Default list of enabled providers defined so that you can extend it
  -- elsewhere in your config, without redefining it, due to `opts_extend`
  sources = {
    default = { 'lsp', 'path' }, -- , 'buffer', 'snippets'
  },

  fuzzy = {
    implementation = "rust",
    prebuilt_binaries = {
      ignore_version_mismatch = true
    },
  },

  signature = {
    enabled = true,
  },
}
