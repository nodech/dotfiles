rm=$(command -v rm)

function rmtrash() {
  local name=$(date +%Y-%m-%d/%H:%M:%S)
  MOUNT_DIR=$(findmnt -T . -J | jq -r '.filesystems[0].target')
  TRASH="$MOUNT_DIR/.TRASH"
  TRASH_DIR="$TRASH/$name"

  mkdir -p $TRASH_DIR
  mv $@ $TRASH_DIR
}

function cltrash() {
  mainDir=$(findmnt -T . -J | jq -r '.filesystems[0].target')
  $rm -rIv $mainDir/.TRASH/*
  $rm -rIv $mainDir/.TRASH/.*
}

function cltrashf() {
  mainDir=$(findmnt -T . -J | jq -r '.filesystems[0].target')
  $rm -rvf $mainDir/.TRASH/*
  $rm -rvf $mainDir/.TRASH/.*
}

alias rrm="$rm"
alias rm='echo use rmtrash'
