rm=$(command -v rm)

function rmtrash() {
  local name target target_mount target_trash_dir
  typeset -A created_trash_dirs
  (( $# > 0 )) || return 0

  if ! command -v findmnt >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    print -u2 "rmtrash: requires findmnt and jq"
    return 1
  fi

  name=$(date +%Y-%m-%d/%H:%M:%S)

  for target in "$@"
  do
    target_mount=$(findmnt -T "$target" -J | jq -r '.filesystems[0].target') || return 1
    target_trash_dir="$target_mount/.TRASH/$name"

    if [[ -z "${created_trash_dirs[$target_mount]}" ]]; then
      mkdir -p "$target_trash_dir" || return 1
      created_trash_dirs[$target_mount]=1
    fi

    mv -- "$target" "$target_trash_dir" || return 1
  done
}

function cltrash() {
  local main_dir trash_dir
  local -a entries

  if ! command -v findmnt >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    print -u2 "cltrash: requires findmnt and jq"
    return 1
  fi

  main_dir=$(findmnt -T . -J | jq -r '.filesystems[0].target') || return 1
  trash_dir="$main_dir/.TRASH"
  [[ -d "$trash_dir" ]] || return 0

  entries=("$trash_dir"/*(N) "$trash_dir"/.*(N))
  (( ${#entries[@]} > 0 )) || return 0

  "$rm" -rIv -- "${entries[@]}"
}

function cltrashf() {
  local main_dir trash_dir
  local -a entries

  if ! command -v findmnt >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    print -u2 "cltrashf: requires findmnt and jq"
    return 1
  fi

  main_dir=$(findmnt -T . -J | jq -r '.filesystems[0].target') || return 1
  trash_dir="$main_dir/.TRASH"
  [[ -d "$trash_dir" ]] || return 0

  entries=("$trash_dir"/*(N) "$trash_dir"/.*(N))
  (( ${#entries[@]} > 0 )) || return 0

  "$rm" -rvf -- "${entries[@]}"
}

alias rrm="$rm"
alias rm='echo use rmtrash'
