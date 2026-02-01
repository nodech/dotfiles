-- Nod statusline.

local config = {
  show_filetype = false,
}

-- only check git status every minute
local GIT_UPDATE_INTERVAL = 60000

local buffer_git_cache = {}
local colors = {
  derror = '%#diagnosticerror#',
  dwarning = '%#diagnosticwarn#',
  dinfo = '%#diagnosticinfo#',
  dhint = '%#diagnostichint#',

  gadd = '%#GitSignsAdd#',
  gchange = '%#GitSignsChange#',
  gdelete = '%#GitSignsDelete#',

  clean = '%*',
}

local filetypeMap = {
  javascript = 'js',
  markdown = 'md'
}

local recover = {}

local function c(color)
  table.insert(recover, color)
  return colors.clean .. colors[color]
end

local function cc()
  local response = colors.clean

  table.remove(recover, #recover)

  if #recover == 0 then
    return response
  end

  return response .. colors[recover[#recover]]
end

local function get_git_state()
  local res = vim.fn.FugitiveExecute('status', '--short');
  local state = {
    cwd = res.cwd,
    untracked = false,
    modified = false,
    staged = false
  }

  for _, line in ipairs(res.stdout) do
    local first = line:sub(1, 1)
    local second = line:sub(2, 2)

    if #line == 0 then
      goto continue
    end

    if first == '?' then
      state.untracked = true
      goto second
    end

    if first ~= ' ' then
      state.staged = true
      goto second
    end

    ::second::

    if second ~= ' ' and second ~= '?' then
      state.modified = true
      goto continue
    end

    ::continue::
  end

  return state
end

local function get_git_info()
  local info = {
    is_git = false
  }

  local success, result = pcall(vim.fn.FugitiveIsGitDir)

  if not success then
    return info
  end

  local is_git = result

  if is_git == 0 then
    return info
  end

  info.is_git = true
  info.branch = vim.fn.FugitiveHead()
  info.summary = get_git_state()

  return info
end

local function format_git_info(info)
  if not info.is_git then
    return ''
  end

  -- Get gitsigns status for current buffer
  local gitsigns_status = vim.b.gitsigns_status_dict
  local hunks = {}

  -- Try to get hunks from gitsigns
  local gs_ok, gitsigns = pcall(require, 'gitsigns')
  if gs_ok and gitsigns.get_hunks then
    hunks = gitsigns.get_hunks() or {}
  end

  local added = gitsigns_status and gitsigns_status.added or 0
  local changed = gitsigns_status and gitsigns_status.changed or 0
  local removed = gitsigns_status and gitsigns_status.removed or 0
  local hunksLen = #hunks

  local gcolor = nil

  if info.summary.modified then
    gcolor = "derror"
  elseif info.summary.staged then
    gcolor = "dwarning"
  else
    gcolor = "gadd"
  end

  local result = {}

  table.insert(result, c(gcolor))

  if info.summary.staged then
    table.insert(result, c('gadd') .. '~' .. cc())
  end

  table.insert(result, info.branch ~= '' and info.branch or '-')

  if info.summary.untracked then
    table.insert(result, c('derror'))
    table.insert(result, '*')
    table.insert(result, cc())
  end

  if added > 0 then
    table.insert(result, c('gadd'))
    table.insert(result, ' +' .. tostring(added))
    table.insert(result, cc())
  end

  if changed > 0 then
    table.insert(result, c('gchange'))
    table.insert(result, ' ~' .. tostring(changed))
    table.insert(result, cc())
  end

  if removed > 0 then
    table.insert(result, c('gdelete'))
    table.insert(result, ' -' .. tostring(removed))
    table.insert(result, cc())
  end

  if hunksLen > 0 then
    table.insert(result, '|' .. c('gadd') .. tostring(hunksLen) .. 'h' .. cc())
  end

  table.insert(result, cc())
  table.insert(result, ' ')

  return table.concat(result)
end

local function get_cached_branch(no)
  local cached = buffer_git_cache[no]
  local now = vim.loop.now()

  if cached == nil then
    local info = get_git_info()
    buffer_git_cache[no] = {
      info = info,
      time = now
    }
    return format_git_info(info)
  end

  if cached.time + GIT_UPDATE_INTERVAL < now then
    cached = {
      info = get_git_info(),
      time = now
    }

    buffer_git_cache[no] = cached
  end

  return format_git_info(cached.info)
end

-- Invalidate git cache on writes
local augroup = vim.api.nvim_create_augroup('nod_statusline', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost', 'FileAppendPost', 'FileWritePost' }, {
  group = augroup,
  pattern = '*',
  callback = function(event)
    local no = event.buf
    if buffer_git_cache[no] then
      buffer_git_cache[no] = nil
    end
  end,
})

return {
  statusline = function()
    local list = {}
    local bufno = vim.api.nvim_get_current_buf()
    local git = get_cached_branch(bufno)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- buffer number
    table.insert(list, '[' .. tostring(bufno) .. '] ')
    -- truncated file path
    table.insert(list, '%<%.99f ')

    -- help ?
    table.insert(list, '%h')
    -- preview ?
    table.insert(list, '%w')
    -- modified/modifiable
    table.insert(list, colors.dwarning)
    table.insert(list, '%m')
    table.insert(list, colors.clean)

    -- read only ?
    table.insert(list, colors.dinfo)
    table.insert(list, '%r')
    table.insert(list, colors.clean)

    -- file type
    if config.show_filetype and vim.bo.filetype ~= '' then
      local filetype = vim.bo.filetype

      table.insert(list, colors.dinfo)
      if filetypeMap[filetype] ~= nil then
        table.insert(list, filetypeMap[filetype])
      else
        table.insert(list, filetype)
      end
      table.insert(list, colors.clean)
    end

    -- git info
    table.insert(list, git)
    -- table.insert(list, tostring(diag))
    if vim.diagnostic.count() ~= 0 then
      table.insert(list, vim.diagnostic.status())
    end

    -- right side
    table.insert(list, '%=')

    -- line number / total lines
    if cursor_pos[2] >= 80 then
      table.insert(list, colors.derror)
    end
    -- table.insert(list, '%l,%c%V% |')
    table.insert(list, '%c%V% |')
    table.insert(list, colors.clean)
    -- Percent in a file
    table.insert(list, '%P')

    return table.concat(list)
  end
}
