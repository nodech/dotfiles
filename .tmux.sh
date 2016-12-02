#!/bin/bash

BATTERY=""

ip=$(ifconfig en0  | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
HOSTNAME=$(whoami)@$ip
DATE=$(date +%H:%M:%S\ %b\ %d)

if [[ -x $(which "system_profiler") ]]
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
fi

echo "#[fg=white]$BATTERY#[fg=green]#[bg=#333333] $HOSTNAME $DATE  "
