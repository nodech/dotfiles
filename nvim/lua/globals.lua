-- https://github.com/nanotee/nvim-lua-guide#tips-3
function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

function _G.modok(name)
  local ok, mod = pcall(require, name)

  if not ok then
    vim.notify('Failed to load ' .. mod, vim.log.levels.WARN)
    return nil
  end

  return mod
end
