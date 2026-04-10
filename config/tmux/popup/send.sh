#!/usr/bin/env zsh
set -eu

source "$HOME/.config/tmux/popup/common.sh"

NO_ENTER=0

if [[ "${1:-}" == "--no-enter" ]]; then
    NO_ENTER=1
    shift
fi

COMMAND="${1:-}"

if [[ -z "$COMMAND" ]]; then
    exit 0
fi

CLIENT="$(tmux display-message -p '#{client_name}')"
CURRENT_PATH="$(tmux display-message -p '#{pane_current_path}')"

popup_set_route_from_context
popup_ensure_target

if [[ "$NO_ENTER" -eq 1 ]]; then
    tmux send-keys -t "$GROUP_SESSION:$WINDOW" "$COMMAND"
else
    tmux send-keys -t "$GROUP_SESSION:$WINDOW" "$COMMAND" C-m
fi

if [[ "$(tmux display-message -p '#{session_name}')" != ${GROUP_PREFIX}-* ]]; then
    exec tmux display-popup -c "$CLIENT" -E -w 80% -h 70% \
        -d "$CURRENT_PATH" \
        "zsh $POPUP_SCRIPT"
fi
