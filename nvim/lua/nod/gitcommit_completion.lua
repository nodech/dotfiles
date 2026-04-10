local M = {}

local cache = {}

local function git_root(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local start = name ~= '' and vim.fs.dirname(name) or vim.loop.cwd()
  local git_dir = vim.fs.find('.git', { upward = true, path = start })[1]
  return git_dir and vim.fs.dirname(git_dir) or nil
end

local function recent_subjects(bufnr)
  local root = git_root(bufnr)
  if not root then
    return {}
  end

  if cache[root] then
    return cache[root]
  end

  local lines = vim.fn.systemlist({
    'git',
    '-C',
    root,
    'log',
    '--no-merges',
    '--format=%s',
    '-n',
    '200',
  })

  if vim.v.shell_error ~= 0 then
    return {}
  end

  local seen = {}
  local items = {}

  for _, line in ipairs(lines) do
    local s = vim.trim(line)
    if s ~= '' and not seen[s] then
      seen[s] = true
      items[#items + 1] = {
        word = s,
        abbr = s,
        menu = '[git]',
      }
    end
  end

  cache[root] = items
  return items
end

function M.omnifunc(findstart, base)
  if findstart == 1 then
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local start = col

    while start > 0 and line:sub(start, start):match('[%w._:/#%-]') do
      start = start - 1
    end

    return start
  end

  return recent_subjects(0)
end

return M
