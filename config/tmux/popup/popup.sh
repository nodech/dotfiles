#!/usr/bin/env zsh
set -eu

source "$HOME/.config/tmux/popup/common.sh"

SCOPE="${1:-window}"

popup_set_route_from_context "$SCOPE"

popup_ensure_target
exec tmux attach-session -t "$GROUP_SESSION"
