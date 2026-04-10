#!/usr/bin/env zsh
set -eu

source "$HOME/.config/tmux/popup/common.sh"

CLIENT="$(tmux display-message -p '#{client_name}')"
CURRENT_SESSION="$(tmux display-message -p '#{session_name}')"
CURRENT_PATH="$(tmux display-message -p '#{pane_current_path}')"

if [[ "$CURRENT_SESSION" == ${GROUP_PREFIX}-* ]]; then
    exec tmux detach-client
fi

popup_open "$CLIENT" "$CURRENT_PATH"
