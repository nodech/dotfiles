#!/bin/bash

# DATE=$(date +%H:%M:%S\ %b\ %d)
DATE=`date +'%Y-%m-%d %H:%M'`
BATTERY=""

SYS_PROFILE=`which system_profiler 2> /dev/null`
I3STATUS=`which i3status 2> /dev/null`

if [[ -x $SYS_PROFILE ]]
then
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
  echo -n "#[fg=white]$BATTERY#[fg=green]#[bg=#333333]"
fi

if [[ -x $I3STATUS ]]
then
  i3status -c ~/.config/i3status/tmux.config
fi

if [[ -x $XDG_CONFIG_HOME/nod/scripts/tasks.js ]]
then
  tasks=$($XDG_CONFIG_HOME/nod/scripts/tasks.js --tmux)

  if [[ -n "$tasks" ]]
  then
    echo -n "$tasks"
  fi
fi

echo "  #[fg=green]$DATE"
