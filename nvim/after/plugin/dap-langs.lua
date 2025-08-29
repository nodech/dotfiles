local ok, dap = pcall(require, 'dap')

if not ok then
  return
end

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = { '/home/nd/dap-deps/js-debug/src/dapDebugServer.js', '${port}'},
  }
}

dap.configurations.javascript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch File',
    program = '${file}',
    cwd = '${workspaceFolder}',
  },
  {
    name = 'Debug Mocha Test File',
    type = 'pwa-node',
    request = 'launch',

    runtimeExecutable = 'node',
    runtimeArgs = {
      './node_modules/.bin/_bmocha',
      '-b',
      '${file}'
    },
    rootPath = "${workspaceFolder}",
    cwd = "${workspaceFolder}",
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen'
  }
}

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-dap',
  name = 'lldb',
  console = 'integratedTerminal',
}

dap.adapters.c = dap.adapters.lldb;

dap.configurations.rust = {
  {
    name = 'Cargo Run',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    initCommands = function()
      -- Find out where to look for the pretty printer Python module
      local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

      local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

      local commands = {}
      local file = io.open(commands_file, 'r')
      if file then
        for line in file:lines() do
          table.insert(commands, line)
        end
        file:close()
      end
      table.insert(commands, 1, script_import)

      return commands
    end,
    -- ...,
  }
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
  {
    name = 'Launch With Arguments',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
        local input = vim.fn.input('Arguments: ')
        return vim.split(input, ' ')
    end,
  },
};
