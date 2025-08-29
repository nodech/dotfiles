-- some nod utils

local nod = {
  keymaps = {},
  commands = {}
}

function nod.merge_map_keys(keymap)
  for k, list in pairs(keymap) do
    local append_to = nod.keymaps[k] or {}

    for _, map in ipairs(list) do
      table.insert(append_to, map)
    end

    nod.keymaps[k] = append_to;
  end
end

function nod.map_keys()
  for mode, maps in pairs(nod.keymaps) do
    for _, map in ipairs(maps) do
      local options = {}

      if map.silent ~= nil then
        options.silent = map.silent
      end

      if map.remap ~= nil then
        options.remap = map.remap
      end

      vim.keymap.set(mode, map.k, map.a, options)
    end
  end
end

function nod.register_aucmds()
  for oname, cmds in pairs(nod.commands) do
    local clear = true

    if cmds.clear ~= nil then
      clear = cmds.clear
    end

    local name = 'nod_' .. oname
    local group = vim.api.nvim_create_augroup(name, { clear = clear })

    for i = 1, #cmds do
      local cmd = cmds[i]
      local opts = {
        group = name,
        desc = cmd.desc,
        pattern = cmd.pattern or '*',
        command = cmd.cmd,
        callback = cmd.cb,
        once = cmd.once,
        nested = cmd.nested
      }

      vim.api.nvim_create_autocmd(cmd.e, opts)
    end
  end
end

return nod
