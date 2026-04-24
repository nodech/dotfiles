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
      --no-pass \
      --claude -- claude "$@"
  )

  rmtrash "$dir"
}

opencode-chat() {
  local dir
  dir="$(mktemp -d --suffix=.chat)"

  (
    cd "$dir"
    dev-shell run --skip-git-check \
      --write . \
      --project chat \
      --no-pass \
      --opencode -- opencode "$@"
  )

  rmtrash "$dir"
}

pi-chat() {
  local dir
  dir="$(mktemp -d --suffix=.chat)"

  (
    cd "$dir"
    dev-shell run --skip-git-check \
      --write . \
      --project chat \
      --pi -- pi "$@"
  )

  rmtrash "$dir"
}
