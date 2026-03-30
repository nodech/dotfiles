# Limits
ulimit -n 2048

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

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Unique
typeset -U path PATH fpath

# Audit completions for now
# Enable/Disable random audits
ZSH_RUN_COMPAUDIT_RANDOM="${ZSH_RUN_COMPAUDIT_RANDOM:-0}"
# Audit for now
ZSH_RUN_COMPAUDIT="${ZSH_RUN_COMPAUDIT:-1}"

source "$ZSH_CFG/util.zsh"
source "$ZSH_CFG/ux-title.zsh"
source "$ZSH_CFG/prompt-theme.zsh"
source "$ZSH_CFG/keybinds.zsh"
source "$ZSH_CFG/paths.zsh"
source "$ZSH_CFG/completions.zsh"

# Features
source "$ZSH_CFG/features/agents.zsh"
source "$ZSH_CFG/features/autosuggestions.zsh"
source "$ZSH_CFG/features/delta.zsh"
source "$ZSH_CFG/features/docker.zsh"
source "$ZSH_CFG/features/fzf.zsh"
source "$ZSH_CFG/features/git.zsh"
source "$ZSH_CFG/features/gpg.zsh"
source "$ZSH_CFG/features/lsd.zsh"
source "$ZSH_CFG/features/ripgrep.zsh"
source "$ZSH_CFG/features/safe-rm.zsh"
source "$ZSH_CFG/features/tmux.zsh"
source "$ZSH_CFG/features/watchexec.zsh"
source "$ZSH_CFG/features/zoxide.zsh"

# Load last
source "$ZSH_CFG/features/syntax-highlighting.zsh"
