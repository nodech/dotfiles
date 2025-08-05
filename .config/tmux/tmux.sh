#!/bin/bash

BATTERY=""

if [[ -x $(which "system_profiler") ]]
then
  ip=$(ifconfig en0  | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
  HOSTNAME=$(whoami)@$ip
  DATE=$(date +%H:%M:%S\ %b\ %d)

  BATTERY=$(system_profiler SPPowerDataType | grep 'mAh' | awk '{print $NF}' | tr '\n' ' ' | awk '{printf("%.2f%%", $1/$2 * 100)}')
  BATTERY=${BATTERY/%%/}
  COLOR="#[fg=green]"

  if [ $(echo "$BATTERY > 80" | bc) -eq 1 ]
  then
    COLOR="#[fg=brightgreen]"
  elif [ $(echo "$BATTERY > 50" | bc) -eq 1 ]
  then
    COLOR="#[fg=green]"
  elif [ $(echo "$BATTERY > 20" | bc) -eq 1 ]
  then
    COLOR="#[fg=yellow]"
  else
    COLOR="#[bg=red]#[fg=white]"
  fi

  BATTERY="$COLOR$BATTERY%"
  echo "#[fg=white]$BATTERY#[fg=green]#[bg=#333333] $HOSTNAME $DATE  "
fi

if [[ -x $(which "i3status") ]]
then
  i3status -c ~/.config/i3status/tmux.config
fi

if [[ -x $XDG_CONFIG_HOME/nod/scripts/tasks.js ]]
then
  tasks=$($XDG_CONFIG_HOME/nod/scripts/tasks.js --tmux)

  if [[ -n "$tasks" ]]
  then
    echo "$tasks"
  fi
fi
