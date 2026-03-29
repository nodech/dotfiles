# Dotfile related completions maintained here.
fpath+=("$ZSH_CFG/completions/")

# Dynamic completions
fpath+=("$HOME/.local/share/zsh/completions")

autoload -Uz compinit
compinit
