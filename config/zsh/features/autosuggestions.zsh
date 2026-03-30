typeset -a _zsh_autosuggestion_candidates=(
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
)

for _zsh_autosuggestion_file in "${_zsh_autosuggestion_candidates[@]}"
do
  if [ -r "$_zsh_autosuggestion_file" ]; then
    source "$_zsh_autosuggestion_file"
    break
  fi
done

unset _zsh_autosuggestion_candidates
unset _zsh_autosuggestion_file
