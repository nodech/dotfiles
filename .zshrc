# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="nod"

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
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/.rbenv/bin"

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

if [ "${NVIMBIN}" = "" ]
then
  NVIMBIN=$(which nvim)
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

nvim () {
  VIMRC="$HOME/.config/nvim/configs/${1}.vimrc"
  if [ $# -gt 0 ]
  then
    if [[ -a $1 ]]
    then
      $NVIMBIN $@
    elif [[ -a "$VIMRC" ]]
    then
      $NVIMBIN -u "$VIMRC" ${@:2}
    else
      $NVIMBIN $@
    fi
  else
    $NVIMBIN
  fi
}

mvim () {
  RUNBIN=$MVIMBIN
  vim $@
  RUNBIN=$VIMBIN
}

download() {
  aria2c --on-bt-download-complete="/Users/nod/.ariaFinished" --on-download-complete="/Users/nod/.ariaFinished" $@
}

startDocker() {
  boot2docker start
  $(boot2docker shellinit)
}

source ~/.awsHosts.sh

export JAVA_HOME="/usr/libexec/java_home"

#GoPATH
export GOPATH="$HOME/Development/Go"
export PATH="$PATH:$GOPATH/bin:`go env GOROOT`/bin"

#OpenVPN Path
export PATH="$PATH:/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-2.3.6"

# Aliases
alias swift='/Applications/Xcode6-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift'

#Ruby Env load stuff
eval "$(rbenv init -)"

#NVM configs
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
