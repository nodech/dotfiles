## AI Aliases
codex-chat() {
  local dir
  dir="$(mktemp -d --suffix=.chat)"

  (
    cd "$dir"
    dev-shell run --skip-git-check \
      --write . \
      --project chat \
      --codex -- codex "$@"
  )

  rmtrash "$dir"
}

claude-chat() {
  local dir
  dir="$(mktemp -d --suffix=.chat)"

  (
    cd "$dir"
    dev-shell run --skip-git-check \
      --write . \
      --project chat \
      --claude -- claude "$@"
  )

  rmtrash "$dir"
}
