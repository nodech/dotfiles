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
