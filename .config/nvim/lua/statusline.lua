local nod = require('nod');

-- only check git status every minute
local GIT_UPDATE_INTERVAL = 60000

local buffer_git_cache = {}
local colors = {
  derror = '%#diagnosticerror#',
  dwarning = '%#diagnosticwarn#',
  dinfo = '%#diagnosticinfo#',
  dhint = '%#diagnostichint#',

  ggadd = '%#gitgutteradd#',
  ggchange = '%#gitgutterchange#',
  ggdelete = '%#gitgutterdelete#',

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

  local bufhunksum = vim.fn.GitGutterGetHunkSummary()
  local hunks = vim.fn.GitGutterGetHunks()
  local hunksLen = #hunks
  local gcolor = nil

  if info.summary.modified then
    gcolor = "derror"
  elseif info.summary.staged then
    gcolor = "dwarning"
  else
    gcolor = "ggadd"
  end

  local result = {}

  table.insert(result, '[')
  table.insert(result, c(gcolor))

  if info.summary.staged then
    table.insert(result, c('ggadd') .. '~' .. cc())
  end

  table.insert(result, info.branch ~= '' and info.branch or '-')

  if info.summary.untracked then
    table.insert(result, c('derror'))
    table.insert(result, '*')
    table.insert(result, cc())
  end

  if bufhunksum and bufhunksum[1] > 0 then
    table.insert(result, c('ggadd'))
    table.insert(result, ' +' .. tostring(bufhunksum[1]))
    table.insert(result, cc())
  end

  if bufhunksum and bufhunksum[2] > 0 then
    table.insert(result, c('ggchange'))
    table.insert(result, ' ~' .. tostring(bufhunksum[2]))
    table.insert(result, cc())
  end

  if bufhunksum and bufhunksum[3] > 0 then
    table.insert(result, c('ggdelete'))
    table.insert(result, ' -' .. tostring(bufhunksum[3]))
    table.insert(result, cc())
  end

  if hunksLen > 0 then
    table.insert(result, ' | ' .. c('ggadd') .. tostring(hunksLen) .. 'h'
                 .. cc())
  end

  table.insert(result, cc())
  table.insert(result, ']')

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

local function get_ale_status(bufno)
  local success, result = pcall(vim.fn['ale#statusline#Count'], bufno)

  if not success then
    return ''
  end

  local counts = result
  local all_errors = counts.error + counts.style_error
  local non_errors = counts.total - all_errors
  local color = colors.ggadd

  if counts.total == 0 then
    return '[' .. colors.ggadd .. 'OK' .. colors.clean .. ']'
  end

  color = all_errors > 0 and colors.derror or colors.dwarning

  return '[' .. color .. tostring(non_errors) .. ' Warn '
         .. tostring(all_errors) .. ' Err' .. colors.clean .. ']'
end

return {
  commands = function()
    nod.commands['sl_postwrites'] = {
      {
        e = { 'BufWritePost', 'FileAppendPost', 'FileWritePost' },
        cb = function (event)
          local no = event.buf
          if buffer_git_cache[no] then
            buffer_git_cache[no] = nil
          end
        end
      }
    }
  end,
  statusline = function()
    local list = {}
    local bufno = vim.api.nvim_get_current_buf()
    local git = get_cached_branch(bufno)
    local ale = get_ale_status(bufno)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local filetype = vim.bo.filetype

    -- buffer number
    table.insert(list, '[' .. tostring(bufno) .. '] ')
    -- truncated file path
    table.insert(list, '%<%.99f ')

    --
    --%h%w%m%r
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
    if filetype ~= '' then
      table.insert(list, '[' .. colors.dinfo)
      if filetypeMap[filetype] ~= nil then
        table.insert(list, filetypeMap[filetype])
      else
        table.insert(list, filetype)
      end
      table.insert(list, colors.clean .. ']')
    end

    -- git info
    table.insert(list, git)
    table.insert(list, tostring(ale))

    -- right side/spli
    table.insert(list, '%=')

    -- line number / total lines
    if cursor_pos[2] >= 80 then
      table.insert(list, colors.derror)
    end
    table.insert(list, '%l,%c%V% |')
    table.insert(list, colors.clean)
    -- Percent in a file
    table.insert(list, '%P')


    return table.concat(list)
  end
}
