#!/usr/bin/env zsh
set -eu

SESSION_PREFIX="scratch-popup"
CLIENT="$(tmux display-message -p '#{client_name}')"
CURRENT_SESSION="$(tmux display-message -p '#{session_name}')"
CURRENT_PATH="$(tmux display-message -p '#{pane_current_path}')"

if [[ "$CURRENT_SESSION" == ${SESSION_PREFIX}* ]]; then
    exec tmux detach-client
fi

exec tmux display-popup -c "$CLIENT" -E -w 80% -h 70% \
    -d "$CURRENT_PATH" \
    "zsh ~/.config/tmux/popup.sh"
