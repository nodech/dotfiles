# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="nod"

# DISABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  #git-flow
  git-extras
  brew
  #extract
  #heroku
  npm
  redis
  #gem
  osx
  web-search
  autojump
  zsh-syntax-highlighting
  #rand-quote
)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/.rbenv/bin"

#nod
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all"
alias psm="ps -eo rss,pid,user,command | awk '{ hr=\$1/1024 ; printf(\"%13.6f Mb \",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf(\"%s \",\$x) } print "" }' | sort"
alias ll="ls -lsah"

psa() {
  ps -eo rss,pid,user,command | sort -n | awk '{ \
    hr[1024**2]="GB"; hr[1024]="MB"; \
    for (x=1024**3; x>=1024; x/=1024) { \
    if ($1>=x) { printf ("%-6.2f %s ", $1/x, hr[x]); break } \
    } } { printf ("%-6s %-10s ", $2, $3) } \
    { for ( x=4 ; x<=NF ; x++ ) { printf ("%s ",$x) } print ("") }'
}

# multiconfig NVIM
if [ "${NVIMBIN}" = "" ]
then
  NVIMBIN=$(which nvim)
fi

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

alias vim='nvim'

download() {
  progressDir='/Users/nod/.ariaDn'
  aria2c \
    --summary-interval=5 \
    --download-result=full \
    --on-bt-download-complete="/Users/nod/.ariaFinished" \
    --on-download-complete="/Users/nod/.ariaFinished" $@ | tee "$progressDir/$(uuidgen)"
}

startDocker() {
  boot2docker start
  $(boot2docker shellinit)
}

# SOME ZSH Configs
DISABLE_AUTO_TITLE=true

source ~/.awsHosts.sh

export JAVA_HOME=$(/usr/libexec/java_home)

#OpenVPN Path
export PATH="$PATH:/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-2.3.6"

# Aliases
alias swift='/Applications/Xcode6-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift'

#Ruby Env load stuff
irbenv() {
  eval "$(rbenv init -)"
}

#NVM configs
invm() {
  export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh
}

#GVM
#igvm() {
source ~/.gvm/scripts/gvm

#GoPATH
export GOPATH="$HOME/Development/Go"
export PATH="$PATH:$GOPATH/bin:`go env GOROOT`/bin"
#}

#ifzf() {
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#}

skip_global_compinit=1
