# ZSH Theme that sync with tmux.
# Color utils
autoload -Uz colors
colors

HIDE_USERNAME=${HIDE_USERNAME:-nd}

_theme_var() {
  name="$1"
  envval="${(P)name}"

  if [[ -n "$TMUX" ]]; then
    local val
    val=$(tmux show-environment -g "$name" 2>/dev/null)
    val="${val#*=}"
    [[ -n "$val" ]] && echo "$val" && return
  elif [[ "$envval" != "" ]]; then
    echo "$envval" && return
  fi

  echo "$2"
}

_hex_fg() {
  local hex="${1#\#}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))
  printf '%%{\e[38;2;%d;%d;%dm%%}' "$r" "$g" "$b"
}

_git_prompt_info() {
  local branch state

  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) \
    || branch=$(command git rev-parse --short HEAD 2>/dev/null) \
    || return

  if [[ -n $(command git status --porcelain 2>/dev/null) ]]; then
    state="$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    state="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  print -r -- "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${state}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}


# Load theme colors from tmux once
_C_GREEN="$(_hex_fg $(_theme_var TMUX_THEME_GREEN 22c55e))"
_C_RED="$(_hex_fg $(_theme_var TMUX_THEME_RED ef4444))"
_C_YELLOW="$(_hex_fg $(_theme_var TMUX_THEME_YELLOW eab308))"
_C_BLUE="$(_hex_fg $(_theme_var TMUX_THEME_BLUE 3b82f6))"
_C_ACCENT="$(_hex_fg $(_theme_var TMUX_THEME_ACCENT 3b82f6))"
_C_RESET="%{$reset_color%}"

setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

local user=""
local ret_status="%(?:%B${_C_GREEN}✓%b:${_C_RED}✗%s)"
local docker_indicator=""

if [[ $(whoami) != "$HIDE_USERNAME" ]]; then
  user=$(whoami)
fi

if [[ -f /.dockerenv ]]; then
  docker_indicator="${_C_BLUE}  ${_C_RESET}"
fi

PROMPT='${docker_indicator}'"${_C_ACCENT}"'${user}'" ${ret_status} ${_C_RESET}"

if [[ $SERVER = true ]]; then
  PROMPT="${_C_ACCENT}"'$(hostname) '"${_C_RESET}"$PROMPT
fi

RPROMPT='$(_git_prompt_info) '"${_C_ACCENT}"'%2c'"${_C_BLUE}${_C_RESET}"

ZSH_THEME_GIT_BRANCH_ICON=''
ZSH_THEME_GIT_PROMPT_PREFIX="${_C_YELLOW}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${_C_RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY=" ${_C_RED}${ZSH_THEME_GIT_BRANCH_ICON}${_C_RESET}"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${_C_GREEN}${ZSH_THEME_GIT_BRANCH_ICON}${_C_RESET}"

reload-theme() {
  source "$ZSH_CFG/prompt-theme.zsh"

  if [[ "$ZSH_KEYMAP_STYLE" == "vi" ]]; then
    source "$ZSH_CFG/prompt-theme-vi.zsh"
  fi

  zle && zle reset-prompt 2>/dev/null
}
