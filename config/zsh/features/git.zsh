alias tgd="GIT_EXTERNAL_DIFF='difft --display=inline' git diff"

gfwd() {
  git checkout $(git rev-list --topo-order HEAD.."$*" | tail -1)
}

alias gback="git checkout HEAD~"
alias gst="git status"
alias gr="git remote"
alias gco="git checkout"
alias gc="git commit --verbose"
