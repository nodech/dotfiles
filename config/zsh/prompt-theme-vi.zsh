_C_MUTED="$(_hex_fg $(_theme_var TMUX_THEME_MUTED 64748b))"

ZSH_VI_MODE="${ZSH_VI_MODE:-INSERT}"

_vi_mode_prompt() {
  case "${ZSH_VI_MODE}" in
    NORMAL)
      print -r -- "${_C_RED}[N]${_C_RESET}"
      ;;
    INSERT)
      print -r -- "${_C_MUTED}[I]${_C_RESET}"
      ;;
    *)
      print -r -- "${_C_MUTED}[${ZSH_VI_MODE}]${_C_RESET}"
      ;;
  esac
}

RPROMPT='$(_git_prompt_info) $(_vi_mode_prompt) '"${_C_ACCENT}"'%2c'"${_C_BLUE}${_C_RESET}"
