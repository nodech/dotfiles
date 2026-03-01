local dap = modok('dap')

if not dap then
  return
end


dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-dap',
  name = 'lldb',
  console = 'integratedTerminal',
}

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.expand('~/.custom_sys/usr/lib/codelldb/adapter/codelldb'),
    args = { '--port', '${port}' },
  },
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
  },
  {
    name = "Debug Rust test (manual binary)",
    type = "codelldb",
    request = "launch",
    -- expressions = "simple",
    expressions = "native",
    sourceLanguages = { "rust" },
    program = function()
      -- Auto-detect: compile and grab the binary path
      local project_name = vim.fn.input("Project name: ", "matiane-core");
      local cmd = 'cargo test -p ' .. project_name .. ' --lib --no-run --message-format=json 2>/dev/null'
        .. " | jq -r 'select(.executable != null) | .executable'"
      local handle = io.popen(cmd)
      local result = handle:read("*a"):gsub("%s+$", "")
      handle:close()
      if result == "" then
        return vim.fn.input("Path to test binary: ")
      end
      return result
    end,
    args = function ()
      local test_name = vim.fn.input("Test name: ", "regex::exec::tests::test_is_match_one_repeat")
      return {
        test_name,
        "--exact",
        "--nocapture",
        "--test-threads=1",
      }
    end,
    cwd = "${workspaceFolder}",
    env = {
      RUSTFLAGS = "-A warnings",
    },
    stopOnEntry = false,
  },
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

local dapui = modok('dapui')

if not dapui then
  return
end

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
