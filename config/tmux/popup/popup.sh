#!/usr/bin/env zsh
set -eu

BASE_SESSION="scratch"
GROUP_PREFIX="scratch-popup"
SOURCE_KEY_RAW="$(tmux display-message -p '#{?session_group,#{session_group},#{session_name}}-#{window_index}')"
SOURCE_KEY="${SOURCE_KEY_RAW//[^A-Za-z0-9_.-]/_}"
GROUP_SESSION="${GROUP_PREFIX}-${SOURCE_KEY}"
WINDOW="$SOURCE_KEY"

# exec > /tmp/popup_debug.log 2>&1
# set -x

tmux has-session -t "$BASE_SESSION" 2>/dev/null || tmux new-session -ds "$BASE_SESSION" -n "$WINDOW"
tmux select-window -t "$BASE_SESSION:$WINDOW" 2>/dev/null || tmux new-window -t "$BASE_SESSION" -n "$WINDOW"
tmux has-session -t "$GROUP_SESSION" 2>/dev/null || tmux new-session -d -t "$BASE_SESSION" -s "$GROUP_SESSION"
tmux select-window -t "$GROUP_SESSION:$WINDOW"
exec tmux attach-session -t "$GROUP_SESSION"
