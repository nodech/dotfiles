local ret_status="%(?:%{$fg_bold[green]%}✓ :%{$fg_bold[red]%}✗ %s)"

PROMPT='%F${ret_status}%f%{$reset_color%}'

if [[ $SERVER = true ]] then
  PROMPT='%F{green}$(hostname) %f'$PROMPT
fi

RPROMPT='$(git_prompt_info) %F{green}%2c%F{blue}%f'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}\ue0a0%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}\ue0a0%f"
