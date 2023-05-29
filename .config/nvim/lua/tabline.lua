#! /usr/bin/env lua

local function title(bufnr)
  local file = vim.fn.bufname(bufnr)
  local buftype = vim.bo[bufnr].buftype
  local filetype = vim.bo[bufnr].filetype

  if buftype == 'help' then
    return 'help: ' .. vim.fn.fnamemodify(file, ':t:r')
  end

  if buftype == 'quickfix' or buftype == 'terminal' then
    return buftype
  end

  if file == '' then
    return '[No Name]'
  end

  return vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
end

local function tabline()
  local line = ''

  for i = 1, vim.fn.tabpagenr('$'), 1 do
    print('...' .. i)
  end
end

return tabline
