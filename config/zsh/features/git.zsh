alias tgd="GIT_EXTERNAL_DIFF='difft --display=inline' git diff"

gfwd() {
  git checkout $(git rev-list --topo-order HEAD.."$*" | tail -1)
}

alias gback="git checkout HEAD~"

# Common
alias gst="git status"
alias gr="git remote"
alias gco="git checkout"
alias gc="git commit --verbose"
alias gp="git push"
alias gl="git pull"
alias ga="git add"
alias gsh="git show"
alias gshps="git show --pretty=short --show-signature"

# Logs
alias glo="git log --oneline --decorate"
alias glog="git log --oneline --decorate --graph"
alias gloga="git log --oneline --decorate --graph --all"

alias glg="git log --stat"
alias glgp="git log --stat --patch"
alias glgg="git log --graph"
alias glgga="git log --graph --decorate --all"

# Worktree
alias gwt="git worktree"
alias gwta="git worktree add"
alias gwtls="git worktree list"
alias gwtmv="git worktree move"
alias gwtrm="git worktree remove"

# Git diff
alias gd="git diff"
alias gds="git diff --staged"

# Git fetch
alias gf="git fetch"
alias gfa="git fetch --all --tags --prune --jobs=10"
