# Dotfile related completions maintained here.
fpath+=("$ZSH_CFG/completions/")

# Dynamic completions
fpath+=("$HOME/.local/share/zsh/completions")

zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
autoload -Uz compaudit

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump"
ZSH_COMP_AUDIT_RANDOM="${ZSH_COMP_AUDIT_RANDOM:-100}"

if [ ! -d "$ZSH_CACHE_DIR" ]; then
  print -u2 "ZSH ERR: Can't find ZSH CACHE DIR"
  return 1
fi

# Run random audits.
if [[ "$ZSH_RUN_COMPAUDIT_RANDOM" == "1" ]]; then
  if (( RANDOM % $ZSH_COMP_AUDIT_RANDOM == 0)); then
    ZSH_RUN_COMPAUDIT=1
  fi
fi

if [[ "$ZSH_RUN_COMPAUDIT" == "1" ]]; then
  _zsh_insecure_completion_paths=($(compaudit 2>/dev/null))

  if (( ${#_zsh_insecure_completion_paths[@]} )); then
    print -u2 "zsh: insecure completion paths detected:"
    print -u2 -l -- "${_zsh_insecure_completion_paths[@]}"
  fi

  unset _zsh_insecure_completion_paths
fi

if [[ "$ZSH_RUN_COMPAUDIT" != "1" ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi
