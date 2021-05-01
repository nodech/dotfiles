#!/bin/bash

# Percentage.
ALERT_THRESHOLD=5

BAT_NOW=$(cat /sys/class/power_supply/BAT0/energy_now)
BAT_FULL=$(cat /sys/class/power_supply/BAT0/energy_full)
BAT_PERCENTAGE=$(($BAT_NOW * 100 / $BAT_FULL))
AC_ON=$(cat /sys/class/power_supply/AC/online)

if [[ $AC_ON -ne 1 && $BAT_PERCENTAGE -lt $ALERT_THRESHOLD ]];
then
  dunstify "! OUR SHIP IS SINKING !"
  dunstify "!! OUR SHIP IS SINKING !!"
  dunstify "!!! OUR SHIP IS SINKING !!!"
fi

exit 0
