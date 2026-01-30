local user=""
local ret_status="%(?:%{$fg_bold[green]%}✓ :%{$fg_bold[red]%}✗ %s)"
local docker_indicator=""

if [[ $(whoami) != "nod" ]] then
  user=$(whoami)
fi

if [[ -f /.dockerenv ]]; then
  # docker_indicator="%F{blue}🐳 %f"
  docker_indicator="%F{blue} %f"
fi

PROMPT='${docker_indicator}%F{green}${user}${ret_status}%f%{$reset_color%}'

if [[ $SERVER = true ]] then
  PROMPT='%F{green}$(hostname) %f'$PROMPT
fi

RPROMPT='$(git_prompt_info) %F{green}%2c%F{blue}%f'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}\ue0a0%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}\ue0a0%f"
