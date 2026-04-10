#!/usr/bin/env zsh

SESSION="scratch"
# WINDOW=$(tmux display-message -p '#{session_name}-#{window_index}')
WINDOW=$(tmux display-message -p '#{session_group}-#{window_index}')


# exec > /tmp/popup_debug.log 2>&1
# set -x

tmux has-session -t "$SESSION" 2>/dev/null || tmux new-session -ds "$SESSION" -n "$WINDOW"
tmux select-window -t "$SESSION:$WINDOW" 2>/dev/null || tmux new-window -t "$SESSION" -n "$WINDOW"
exec tmux attach-session -t "$SESSION:$WINDOW"
