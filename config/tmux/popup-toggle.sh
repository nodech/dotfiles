  if tmux list-clients -t scratch 2>/dev/null | grep -q .; then
      tmux detach-client -s scratch
  else
      tmux display-popup -E -w 80% -h 70% \
          -d "$(tmux display-message -p '#{pane_current_path}')" \
          "zsh ~/.config/tmux/popup.sh"
  fi
