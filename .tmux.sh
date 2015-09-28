#!/bin/bash

BATTERY=""

HOSTNAME=$(hostname)
DATE=$(date +%H:%M:%S\ %b\ %d)

if [[ -x $(which "system_profiler") ]]
then
  BATTERY=$(system_profiler SPPowerDataType | grep 'mAh' | awk '{print $NF}' | tr '\n' ' ' | awk '{printf("%.2f%%", $1/$2 * 100)}')
fi

echo "$BATTERY $HOSTNAME $DATE  "
