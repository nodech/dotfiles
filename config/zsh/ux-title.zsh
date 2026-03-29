# UI / UX
DISABLE_AUTO_TITLE=false

autoload -Uz add-zsh-hook

# Dyn title based on cwd.
_zsh_update_title() {
  # Get the absolute path
  local fullpath="${PWD}"

  # Replace $HOME with ~
  fullpath="${fullpath/#$HOME/~}"

  # Extract parent and current directory
  local current="${fullpath##*/}"
  local parent="${fullpath%/*}"

  # If we're at root or home, adjust parent display
  if [[ "$parent" == "$fullpath" ]]; then
    parent=""
  elif [[ "$parent" == "~" || "$parent" == "/" ]]; then
    parent="$parent"
  else
    parent="${parent##*/}"
  fi

  # Combine parent/current or just show fullpath if no parent
  local display_path
  if [[ -n "$parent" ]]; then
    display_path="$parent/$current"
  else
    display_path="$fullpath"
  fi

  # Set terminal title
  local window_title="\033]0;${display_path}\007"
  echo -ne "$window_title"
}

add-zsh-hook precmd _zsh_update_title
