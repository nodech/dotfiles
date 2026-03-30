rm=$(command -v rm)

function rmtrash() {
  local name mount_dir
  (( $# > 0 )) || return 0

  if ! command -v findmnt >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    print -u2 "rmtrash: requires findmnt and jq"
    return 1
  fi

  name=$(date +%Y-%m-%d/%H:%M:%S)
  mount_dir=$(findmnt -T . -J | jq -r '.filesystems[0].target') || return 1
  TRASH="$mount_dir/.TRASH"
  TRASH_DIR="$TRASH/$name"

  mkdir -p "$TRASH_DIR" || return 1
  mv -- "$@" "$TRASH_DIR"
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
