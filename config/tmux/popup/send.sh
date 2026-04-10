#!/usr/bin/env zsh
set -eu

BASE_SESSION="scratch"
GROUP_PREFIX="scratch-popup"
NO_ENTER=0

if [[ "${1:-}" == "--no-enter" ]]; then
    NO_ENTER=1
    shift
fi

COMMAND="${1:-}"

if [[ -z "$COMMAND" ]]; then
    exit 0
fi

CURRENT_SESSION="$(tmux display-message -p '#{session_name}')"
CURRENT_WINDOW="$(tmux display-message -p '#{window_name}')"
CLIENT="$(tmux display-message -p '#{client_name}')"
CURRENT_PATH="$(tmux display-message -p '#{pane_current_path}')"

if [[ "$CURRENT_SESSION" == ${GROUP_PREFIX}-* ]]; then
    GROUP_SESSION="$CURRENT_SESSION"
    WINDOW="$CURRENT_WINDOW"
else
    SOURCE_KEY_RAW="$(tmux display-message -p '#{?session_group,#{session_group},#{session_name}}-#{window_index}')"
    SOURCE_KEY="${SOURCE_KEY_RAW//[^A-Za-z0-9_.-]/_}"
    GROUP_SESSION="${GROUP_PREFIX}-${SOURCE_KEY}"
    WINDOW="$SOURCE_KEY"
fi

tmux has-session -t "$BASE_SESSION" 2>/dev/null || tmux new-session -ds "$BASE_SESSION" -n "$WINDOW"
tmux select-window -t "$BASE_SESSION:$WINDOW" 2>/dev/null || tmux new-window -t "$BASE_SESSION" -n "$WINDOW"
tmux has-session -t "$GROUP_SESSION" 2>/dev/null || tmux new-session -d -t "$BASE_SESSION" -s "$GROUP_SESSION"
tmux select-window -t "$GROUP_SESSION:$WINDOW"

if [[ "$NO_ENTER" -eq 1 ]]; then
    tmux send-keys -t "$GROUP_SESSION:$WINDOW" "$COMMAND"
else
    tmux send-keys -t "$GROUP_SESSION:$WINDOW" "$COMMAND" C-m
fi

CURRENT_TARGET_SESSION="$(tmux display-message -p '#{session_name}')"
if [[ "$CURRENT_TARGET_SESSION" != ${GROUP_PREFIX}-* ]]; then
    exec tmux display-popup -c "$CLIENT" -E -w 80% -h 70% \
        -d "$CURRENT_PATH" \
        "zsh ~/.config/tmux/popup/popup.sh"
fi
