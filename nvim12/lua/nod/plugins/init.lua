local gh = function(x) return 'https://github.com/' .. x end
local shell = function(path, cmd)
  vim.system({ 'sh', '-c', cmd }, { cwd = path })
end

local plugins = {
  -- fzf fuzzy finder.
  {
    gh('junegunn/fzf.vim'),
    config = 'nod.plugins.fzf'
  },

  -- Treesitter
  {
    gh('nvim-treesitter/nvim-treesitter'),
    hook = function() vim.cmd('TSUpdate') end,
    config = 'nod.plugins.treesitter',
  },
  {
    gh('nvim-treesitter/nvim-treesitter-context'),
    config = 'nod.plugins.treesitter-context',
  },
  {
    {
      src = gh('nvim-treesitter/nvim-treesitter-textobjects'),
      version = 'main',
    },
    config = 'nod.plugins.treesitter-textobjects',
  },
}

local plug2hook = {}

local load_list = vim.iter(plugins)
  :map(function(x)
    -- index post install/update hooks
    if x.hook then
      plug2hook[x[1]] = x.hook
    end

    return x.src or x[1]
  end)
  :totable()

local hook = function(ev)
  if plug2hook[ev.data.spec.src] then
    vim.cmd.packadd(ev.data.spec.name)
    plug2hook[ev.data.spec.src]()
  end
end

local update_group = vim.api.nvim_create_augroup('nod_packs', { clear = true });
vim.api.nvim_create_autocmd('PackChanged', {
  group = update_group,
  callback = hook
});

vim.pack.add(load_list)

for _, mod in ipairs(plugins) do
  local path = mod.src or mod[1]
  local configs = mod.config;

  if mod.config then
    local success, err = pcall(require, mod.config)

    if not success then
      vim.notify('Failed to load ' .. mod.config .. ': ' .. err, vim.log.levels.WARN)
    end
  end
end
