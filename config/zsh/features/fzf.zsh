command -v fzf >/dev/null 2>&1 || return

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
# export FZF_DEFAULT_OPTS="--walker-skip=.git --preview 'bat --style=numbers --color=always --line-range :500 {}'"

source <(fzf --zsh)

[ -f "$XDG_CONFIG_HOME/fzf/fzf-git.sh" ] && source "$XDG_CONFIG_HOME/fzf/fzf-git.sh"
