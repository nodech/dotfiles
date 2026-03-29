bindkey -e

# Open command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

bindkey '^U' backward-kill-line
bindkey '^K' kill-line
bindkey '^[k' kill-whole-line
