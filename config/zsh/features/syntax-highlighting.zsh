# Load syntax highlighting late so it can wrap previously defined widgets.
typeset -a _zsh_syntax_hl_candidates=(
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)

for _zsh_syntax_hl_file in "${_zsh_syntax_hl_candidates[@]}"
do
  if [ -r "$_zsh_syntax_hl_file" ]; then
    source "$_zsh_syntax_hl_file"
    break
  fi
done

unset _zsh_syntax_hl_candidates
unset _zsh_syntax_hl_file
