function find-up-home() {
  local dir=$1
  local name=$2

  if [[ -f "$dir/$name" ]];then
    echo "$dir/$name"
    return 0
  fi

  # Not Found
  if [[ "$dir" == "/" ]];then
    return 1
  fi

  # Not found.
  if [[ "$dir" == "$HOME" ]];then
    return 1
  fi

  find-up-home "$(dirname -- "$dir")" "$name"
  return $?
}

function cpv() {
  rsync -a --no-i-r --info=progress2 "$@"
}
