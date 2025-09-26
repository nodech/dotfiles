#zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="nod"

# DISABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  git-extras
  docker
  npm
  golang
  rust
  #kubectl
  zoxide
)


local rm=$(which rm);
alias rmunsafe="$rm"

source $ZSH/oh-my-zsh.sh
# eval "$(starship init zsh)"

export EDITOR='nvim'
export SHELL=`which zsh`

# GPG_TTY Fix
GPG_TTY=$(tty)
export GPG_TTY

# SOME ZSH Configs
#DISABLE_AUTO_TITLE=true
DISABLE_AUTO_TITLE=false

function precmd() {
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

# Include system and bin paths
source ~/.zshrc.paths

# Setup some zsh aliases
source ~/.zshrc.aliases

# Setup some hsd utilities
source ~/.zshrc.hsd

# Setup rootless docker
source ~/.zshrc.docker

#Ruby Env load stuff
irbenv() {
  eval "$(rbenv init -)"
}

#NVM configs
invm() {
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
}

icpan() {
  cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
}

iaws() {
  source /usr/local/bin/aws_zsh_completer.sh
}

# ifzf() {
export FZF_DEFAULT_OPTS="--walker-skip=.git --preview 'bat --style=numbers --color=always --line-range :500 {}'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }

# LLVM - Update (OSX only hack to fix llvm)
illvm() {
  PATH="/usr/local/Cellar/llvm/6.0.0/bin:$PATH"
  export LDFLAGS=-L/usr/local/opt/llvm/lib
  export CPPFLAGS=-I/usr/local/opt/llvm/include
}

## Bindings

bindkey "^k" up-line-or-beginning-search
bindkey "^j" down-line-or-beginning-search
#bindkey "^l" vi-forward-word
#bindkey "^h" vi-backward-word
#bindkey "^[" clear-screen

# zsh ac
skip_global_compinit=0

# Turn off KQUEUE in tmux 2.2
export EVENT_NOKQUEUE=1 

tmn() {
  arg=$1
  name=`echo "$1" | cut -d '-' -f1`
  id=`echo "$1" | cut -d '-' -f2`

  if [[ "$name" == "" ]] || ! [[ "$id" =~ '^[0-9]+$' ]]; then
    echo "Format is name-id. Where name is a string and id is a number."
  else
    tmux new -A -t "$name" -s "$name-$id" ${@:2}
  fi
}

# Linux?
export XDG_CONFIG_HOME=$HOME/.config

# Linux version

# if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]];
# then
#   source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# fi

ulimit -n 2048

### Experiment
function findUpHome() {
  local dir=$1
  local name=$2

  if [[ -f "$dir/$name" ]];then
    echo "$dir/$name"
    exit 0
  fi

  # Not Found
  if [[ "$dir" == "/" ]];then
    exit 1
  fi

  # Not found.
  if [[ "$dir" == "$HOME" ]];then
    exit 1
  fi

  findUpHome $(dirname $dir) $name
  exit $?
}

function printPkg() {
  local res=$(findUpHome `pwd` "package.json")

  if [[ "$res" != "" ]]; then
    cat $res | jq -r '.name+"@"+.version' 2> /dev/null
  fi
}

# export CC="ccache gcc"
# export CXX="ccache c++"
export RUSTC_WRAPPER="$sccache"
export EM_CACHE="$HOME/.cache/emscripten"

## ASDF version manager..
# export ASDF_DATA_DIR="/your/custom/data/dir"
# export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

export HISTSIZE=1000000
export SAVEHIST=1000000
setopt EXTENDED_HISTORY

# bun completions
[ -s "/home/nd/.bun/_bun" ] && source "/home/nd/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
