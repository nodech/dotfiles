local HOME = os.getenv("HOME")

-- local coc_configs = {
--   ["colors.enable"] = true,
--   ["suggest.noselect"] = true,
-- };

-- for k, v in pairs(coc_configs) do
--   vim.fn["coc#config"](k, v)
-- end


-- Unfortunately coc-flow and coc-tsserver are incompatible.
if vim.env.ONLY_FLOW ~= nil then
  vim.g.coc_config_home = HOME .. '/.config/nvim/coc-configs/flow'
end

-- else
--   vim.g.coc_config_home = HOME .. '/.config/nvim/coc-configs/general'
-- end
