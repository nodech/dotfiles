# nod.zsh-theme - Syncs with tmux theme

_theme_var() {
  if [[ -n "$TMUX" ]]; then
    local val
    val=$(tmux show-environment -g "$1" 2>/dev/null)
    val="${val#*=}"
    [[ -n "$val" ]] && echo "$val" && return
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

# Load theme colors from tmux once
_C_GREEN="$(_hex_fg $(_theme_var TMUX_THEME_GREEN 22c55e))"
_C_RED="$(_hex_fg $(_theme_var TMUX_THEME_RED ef4444))"
_C_YELLOW="$(_hex_fg $(_theme_var TMUX_THEME_YELLOW eab308))"
_C_BLUE="$(_hex_fg $(_theme_var TMUX_THEME_BLUE 3b82f6))"
_C_ACCENT="$(_hex_fg $(_theme_var TMUX_THEME_ACCENT 3b82f6))"
_C_RESET="%{$reset_color%}"

setopt TRANSIENT_RPROMPT

# ── Prompt setup ──
local user=""
local ret_status="%(?:%B${_C_GREEN}✓%b:${_C_RED}✗ %s)"
local docker_indicator=""

if [[ $(whoami) != "nod" ]]; then
  user=$(whoami)
fi

 if [[ -f /.dockerenv ]]; then
  # docker_indicator="${_C_BLUE} 🐳 ${_C_RESET}"
  docker_indicator="${_C_BLUE}  ${_C_RESET}"
 fi

# PROMPT='${docker_indicator}'"${_C_ACCENT}"'${user}'"${ret_status}${_C_RESET}"
PROMPT='${docker_indicator}'"${_C_ACCENT}"'${user}'" ${ret_status} ${_C_RESET}"

if [[ $SERVER = true ]]; then
  PROMPT="${_C_ACCENT}"'$(hostname) '"${_C_RESET}"$PROMPT
fi

RPROMPT='$(git_prompt_info) '"${_C_ACCENT}"'%2c'"${_C_BLUE}${_C_RESET}"

ZSH_THEME_GIT_PROMPT_PREFIX="${_C_YELLOW}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${_C_RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY=" ${_C_RED}\ue0a0${_C_RESET}"
ZSH_THEME_GIT_PROMPT_CLEAN=" ${_C_GREEN}\ue0a0${_C_RESET}"
