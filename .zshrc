#zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="nod"

# DISABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  git-extras
  brew
  docker
  npm
  kubectl
  redis
  osx
  web-search
  autojump
  zsh-autosuggestions
)


source $ZSH/oh-my-zsh.sh

# OSX Paths
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

# Rbenv
export PATH="$PATH:$HOME/.rbenv/bin"

#gpgbin
export PATH="$PATH:/usr/local/opt/gnupg/libexec/gpgbin"

#nod
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all"
alias psm="ps -eo rss,pid,user,command | awk '{ hr=\$1/1024 ; printf(\"%13.6f Mb \",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf(\"%s \",\$x) } print "" }' | sort"
alias ll="ls -lsah"

# GPG_TTY Fix
GPG_TTY=$(tty)
export GPG_TTY

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
  progressDir="$HOME/.ariaDn"
  aria2c \
    --summary-interval=5 \
    --download-result=full \
    --on-bt-download-complete="$HOME/.ariaFinished" \
    --on-download-complete="$HOME/.ariaFinished" $@ | tee "$progressDir/$(uuidgen)"
}

# SOME ZSH Configs
DISABLE_AUTO_TITLE=true

# Setup TMUXINATOR
export EDITOR='nvim'
export SHELL=$(which zsh)

muxRefresh() {
  tmux kill-session -t $1
  tmuxinator start $1
}

imux() {
  irbenv
  source ~/.bin/tmuxinator.zsh
}


export JAVA_HOME=$(/usr/libexec/java_home 2> /dev/null)
#export ANDROID_HOME=~/Library/Android/sdk

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

iaws() {
  source /usr/local/bin/aws_zsh_completer.sh
}

#GVM

#GoPATH
export GOPATH="$HOME/Development/Go"
export PATH="$PATH:$GOPATH/bin:`go env GOROOT`/bin"

#Cargo PATH
export RUST_SRC_PATH="$HOME/.rust/rust-1.22.1/src"
[ -f ~/.zfunc/_rustup ] && fpath+=~/.zfunc

#ifzf() {
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#}


#Custom bins
export PATH=~/.bin:$PATH

#Cuda PATHS
export PATH=/usr/local/cuda/bin:$PATH
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH

#LLVM - Update
llvm() {
  PATH="/usr/local/Cellar/llvm/3.9.0/bin:$PATH"
}



## Bindings

bindkey "^k" up-line-or-beginning-search
bindkey "^j" down-line-or-beginning-search
#bindkey "^l" vi-forward-word
#bindkey "^h" vi-backward-word
#bindkey "^[" clear-screen

alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
alias rm='echo use rmtrash'

# alacrity changes
alias cgd='cp ~/.alacritty.dark.yml ~/.alacritty.yml'
alias cgw='cp ~/.alacritty.white.yml ~/.alacritty.yml'

# zsh ac
skip_global_compinit=0

alert() {
  < /dev/urandom gtr -dc 01 | head -c 10000 | lolcat
}

# Turn off KQUEUE in tmux 2.2
export EVENT_NOKQUEUE=1 

# Load Rust
if [ -f "$HOME/.cargo/env" ]; then source $HOME/.cargo/env; fi

#source ~/.env
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/openssl/bin:$PATH"


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.sdk/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/.sdk/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.sdk/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/.sdk/google-cloud-sdk/completion.zsh.inc"; fi

