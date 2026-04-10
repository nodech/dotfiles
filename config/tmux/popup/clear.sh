#!/usr/bin/env zsh
set -eu

source "$HOME/.config/tmux/popup/common.sh"

tmux list-sessions -F '#{session_name}' 2>/dev/null | while IFS= read -r session; do
    [[ "$session" == ${GROUP_PREFIX}-* ]] || continue
    tmux kill-session -t "$session"
done

if tmux has-session -t "$BASE_SESSION" 2>/dev/null; then
    tmux kill-session -t "$BASE_SESSION"
fi
