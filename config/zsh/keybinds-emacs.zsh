bindkey -e

# Open command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

bindkey '^U' backward-kill-line
bindkey '^K' kill-line
bindkey '^[k' kill-whole-line

# autoload -U history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
#
# bindkey '^K' history-beginning-search-backward-end
# bindkey '^J' history-beginning-search-forward-end

autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
