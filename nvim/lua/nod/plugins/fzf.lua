vim.cmd [[
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

  let g:fzf_vim = {}
  let g:fzf_vim.listproc = { list -> fzf#vim#listproc#location(list) }

  function! UpdateFzfLayout()
    let g:fzf_layout = {
      \ 'window': {
        \ 'width': min([240, float2nr(&columns * 0.8)]),
        \ 'height': 0.8,
        \ 'border': 'rounded'
      \ }
    \ }
  endfunction

  call UpdateFzfLayout()
  autocmd VimResized * call UpdateFzfLayout()

  let g:fzf_vim.preview_window = ['right,50%,<100(hidden)', 'ctrl-/']

  command! -bang -nargs=? GFilesCwd
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == '?' ? { 'dir': getcwd(), 'placeholder': '' } : { 'dir': getcwd() }), <bang>0)

  command! -nargs=? -complete=dir Dirs
  \ call fzf#run(fzf#wrap({ 'source': 'fd --type d', 'dir': <q-args>, 'sink': 'e' }))
]]


vim.cmd([[
  function! GitCommitSubjectPick() abort
    let l:root = finddir('.git', expand('%:p:h') . ';')
    if empty(l:root)
      let l:root = finddir('.git', getcwd() . ';')
    endif
    if empty(l:root)
      echo 'not in git repo'
      return
    endif

    let l:dir = fnamemodify(l:root, ':h')

    call fzf#run(fzf#wrap({
      \ 'source': 'git -C ' . shellescape(l:dir) . ' log --no-merges --format=%s -n 200 | awk ''!seen[$0]++''',
      \ 'sink': function('GitCommitSubjectInsert'),
      \ 'options': '--prompt="Commit subject> " --layout=reverse --border'
      \ }))
  endfunction

  function! GitCommitSubjectInsert(line) abort
    if empty(a:line)
      return
    endif

    call setline(1, a:line)
    call cursor(1, strlen(a:line) + 1)
  endfunction
]])

local nmap = function(key, cmd)
  vim.keymap.set('n', key, ':' .. cmd .. '<CR>')
end

nmap('<leader>lb', 'Buffers')
nmap('<leader>lf', 'GFiles')
nmap('<leader>lF', 'GFilesCwd')
nmap('<leader>ll', 'Files')
nmap('<leader>lw', 'Windows')
nmap('<leader>lg', 'GFiles?')
nmap('<leader>ld', 'Dirs')

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  callback = function(args)
    vim.keymap.set('n', '<leader>lm', '<cmd>call GitCommitSubjectPick()<CR>', {
      buffer = args.buf,
      silent = true,
      desc = 'Pick recent commit subject',
    })
  end,
})
