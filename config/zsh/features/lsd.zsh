alias ll="ls -lsah"

command -v lsd >/dev/null 2>&1 || return

alias l="lsd -l"
alias la="lsd -la"
alias ll="lsd -lah"
alias lt="lsd --tree"
alias ls="lsd"
