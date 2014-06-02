# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

# DISABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  git-flow
  git-extras
  brew
  extract
  heroku
  npm
  redis
  brew
  gem
  osx
  web-search
  autojump
  zsh-syntax-highlighting
  rand-quote
)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

#nod
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all"
alias ll="ls -lsah"

# multiconfig VIM
if [ "${VIMBIN}" = "" ]
then
  VIMBIN=$(which vim)
  MVIMBIN=$(which mvim)
  RUNBIN=$VIMBIN
fi

vim () {
  VIMRC="$HOME/.vim/configs/${1}.vimrc"
  if [ $# -gt 0 ]
  then
    if [[ -a $1 ]]
    then
      $RUNBIN $@
    elif [[ -a "$VIMRC" ]]
    then
      $RUNBIN -u "$VIMRC" ${@:2}
    else
      $RUNBIN $@
    fi
  else
    $RUNBIN
  fi
}

mvim () {
  RUNBIN=$MVIMBIN
  vim $@
  RUNBIN=$VIMBIN
}
