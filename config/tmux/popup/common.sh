#!/usr/bin/env zsh

BASE_SESSION="scratch"
GROUP_PREFIX="scratch-popup"
POPUP_SCRIPT="$HOME/.config/tmux/popup/popup.sh"
POPUP_WIDTH="80%"
POPUP_HEIGHT="70%"

popup_source_key() {
    local source_key_raw

    source_key_raw="$(tmux display-message -p '#{?session_group,#{session_group},#{session_name}}-#{window_index}')"
    echo "${source_key_raw//[^A-Za-z0-9_.-]/_}"
}

popup_set_route_from_context() {
    local current_session current_window

    current_session="$(tmux display-message -p '#{session_name}')"
    current_window="$(tmux display-message -p '#{window_name}')"

    if [[ "$current_session" == ${GROUP_PREFIX}-* ]]; then
        GROUP_SESSION="$current_session"
        WINDOW="$current_window"
        SOURCE_KEY="${GROUP_SESSION#${GROUP_PREFIX}-}"
    else
        SOURCE_KEY="$(popup_source_key)"
        GROUP_SESSION="${GROUP_PREFIX}-${SOURCE_KEY}"
        WINDOW="$SOURCE_KEY"
    fi
}

popup_ensure_target() {
    tmux has-session -t "$BASE_SESSION" 2>/dev/null || tmux new-session -ds "$BASE_SESSION" -n "$WINDOW"
    tmux select-window -t "$BASE_SESSION:$WINDOW" 2>/dev/null || tmux new-window -t "$BASE_SESSION" -n "$WINDOW"
    tmux has-session -t "$GROUP_SESSION" 2>/dev/null || tmux new-session -d -t "$BASE_SESSION" -s "$GROUP_SESSION"
    tmux select-window -t "$GROUP_SESSION:$WINDOW"
}

popup_open() {
    local client cpath

    client="$1"
    cpath="$2"

    exec tmux display-popup -c "$client" -E -w "$POPUP_WIDTH" -h "$POPUP_HEIGHT" \
        -d "$cpath" \
        "zsh $POPUP_SCRIPT"
}
