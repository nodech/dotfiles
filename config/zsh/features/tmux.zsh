# alias ta='tmux attach -t'
# alias tad='tmux attach -d -t'
# alias ts='tmux new-session -s'
# alias tl='tmux list-sessions'
# alias tksv='tmux kill-server'
# alias tkss='tmux kill-session -t'

tmn() {
  local name id
  name=$(echo "$1" | cut -d '-' -f1)
  id=$(echo "$1" | cut -d '-' -f2)

  if [[ "$name" == "" ]] || ! [[ "$id" =~ '^[0-9]+$' ]]; then
    echo "Format is name-id. Where name is a string and id is a number."
  else
    tmux new -A -t "$name" -s "$name-$id" "${@:2}"
  fi
}
