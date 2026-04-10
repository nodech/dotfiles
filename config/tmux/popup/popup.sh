#!/usr/bin/env zsh
set -eu

source "$HOME/.config/tmux/popup/common.sh"

popup_set_route_from_context

popup_ensure_target
exec tmux attach-session -t "$GROUP_SESSION"
