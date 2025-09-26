local ok, ppd = pcall(require, 'ppd')

if not ok then
  return
end

ppd.setup({
    -- Automatically push paths from DirChanged events onto the stack
    auto_cd = true,
    dedup = {
        -- Do not push a path that is the same as the newest path on the stack
        top = true,
        -- Do not push any duplicates onto the stack
        all = false,
    },
    notify = {
        -- Display the stack on all pushd invocations
        on_pushd = true,
        -- Display the stack on all popd invocations
        on_popd = true,
    },
})
