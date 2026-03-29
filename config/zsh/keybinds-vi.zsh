bindkey -v

function zle-keymap-select {
  case $KEYMAP in
    vicmd) ZSH_VI_MODE='NORMAL' ;;
    viins|main) ZSH_VI_MODE='INSERT' ;;
    *) ZSH_VI_MODE="$KEYMAP" ;;
  esac
  zle reset-prompt
}

function zle-line-init {
  ZSH_VI_MODE='INSERT'
  zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init
