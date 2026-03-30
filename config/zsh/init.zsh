echo "Initializing new ZSH... WIP"

# Limits
ulimit -u 2048

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt EXTENDED_HISTORY

# "emacs" or "vi"
ZSH_KEYMAP_STYLE_DEFAULT="emacs"
ZSH_KEYMAP_STYLE="${ZSH_KEYMAP_STYLE:-$ZSH_KEYMAP_STYLE_DEFAULT}"

export EDITOR='nvim'
export SHELL=$(command -v zsh)

# Unique
typeset -U path PATH fpath

# Audit completions for now
# Enable/Disable random audits
ZSH_RUN_COMPAUDIT_RANDOM="${ZSH_RUN_COMPAUDIT_RANDOM:-0}"
# Audit for now
ZSH_RUN_COMPAUDIT="${ZSH_RUN_COMPAUDIT:-1}"

source "$ZSH_CFG/ux-title.zsh"
source "$ZSH_CFG/prompt-theme.zsh"
source "$ZSH_CFG/keybinds.zsh"
source "$ZSH_CFG/paths.zsh"
source "$ZSH_CFG/completions.zsh"
