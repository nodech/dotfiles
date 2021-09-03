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
  #kubectl
  osx
  autojump
)


local rm=$(which rm);
alias rmunsafe="$rm"

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export SHELL=`which zsh`

# GPG_TTY Fix
GPG_TTY=$(tty)
export GPG_TTY

# SOME ZSH Configs
DISABLE_AUTO_TITLE=true

# Include system and bin paths
source ~/.zshrc.paths

# Setup some zsh aliases
source ~/.zshrc.aliases

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

if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]];
then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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

function get_prompt() {
  local bnet=$(get_bnet)
  local pkg=$(printPkg)

  echo -n $pkg $bnet
}

# Bcoin related
function btcreg() {
  cd ~/.bcoin/regtest/
  source env.sh
  #invm
}

function hsdreg() {
  cd ~/.hsd/regtest
  source env.sh
  #invm
}

function get_bnet() {
  if [[ "$BCOIN_NETWORK" != "" ]] then
    echo -n "b["$BCOIN_NETWORK"@"${BCOIN_PREFIX/$HOME/"~"}"]"
  fi

  return ""
}

function bmwatch() {
  find . -iname '*.js' \
  | grep -v 'node_modules' \
  | entr -rc $(which bmocha) $@
}

function bwatch() {
  find . -iname '*.js' \
  | grep -v 'node_modules' \
  | entr -rc $@
}

## Bcoin related

## ASDF version manager..
source $HOME/.asdf/asdf.sh
source $HOME/.asdf/completions/asdf.bash
