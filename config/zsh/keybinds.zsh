if [[ "$ZSH_KEYMAP_STYLE" == "vi" ]]; then
  source "$ZSH_CFG/keybinds-vi.zsh"
  source "$ZSH_CFG/prompt-theme-vi.zsh"
else
  source "$ZSH_CFG/keybinds-emacs.zsh"
fi
