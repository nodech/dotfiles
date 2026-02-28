#!/bin/bash

# ── Pull theme colors from tmux ──
theme_var() {
  local val
  val=$(tmux show-environment -g "$1" 2>/dev/null)
  echo "${val#*=}"
}

T_BG=$(theme_var TMUX_THEME_BG)
T_FG=$(theme_var TMUX_THEME_FG)
T_GREEN=$(theme_var TMUX_THEME_GREEN)
T_YELLOW=$(theme_var TMUX_THEME_YELLOW)
T_RED=$(theme_var TMUX_THEME_RED)
T_BLUE=$(theme_var TMUX_THEME_BLUE)
T_ACCENT=$(theme_var TMUX_THEME_ACCENT)

# Fallbacks if no theme is loaded
: "${T_BG:=#333333}" "${T_FG:=white}" "${T_GREEN:=green}"
: "${T_YELLOW:=yellow}" "${T_RED:=red}" "${T_BLUE:=blue}" "${T_ACCENT:=blue}"

# DATE=$(date +%H:%M:%S\ %b\ %d)
DATE=`date +'%Y-%m-%d %H:%M'`
BATTERY=""

if [[ -x $XDG_CONFIG_HOME/nod/scripts/tasks.js ]]
then
  tasks=$($XDG_CONFIG_HOME/nod/scripts/tasks.js --tmux)

  if [[ -n "$tasks" ]]
  then
    echo -n "$tasks"
  fi
fi


BAT_PATH="/sys/class/power_supply/BAT0"

[[ ! -d $BAT_PATH ]] && BAT_PATH="/sys/class/power_supply/BAT1"

if [[ -d $BAT_PATH ]]; then
  BATTERY=$(cat "$BAT_PATH/capacity" 2>/dev/null)
  STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)

  if [[ -n $BATTERY ]]; then
    if [ "$BATTERY" -gt 80 ]; then
      COLOR="#[fg=$T_GREEN,bg=$T_BG,bold]"
      ICON="󰁹"
    elif [ "$BATTERY" -gt 50 ]; then
      COLOR="#[fg=$T_GREEN,bg=$T_BG]"
      ICON="󰁾"
    elif [ "$BATTERY" -gt 20 ]; then
      COLOR="#[fg=$T_YELLOW,bg=$T_BG]"
      ICON="󰁼"
    else
      COLOR="#[fg=$T_RED,bg=$T_BG]"
      ICON="󰁺"
    fi

    if [[ "$STATUS" == "Charging" ]]; then
      ICON="󰂄"
    elif [[ "$STATUS" == "Not charging" ]]; then
      ICON="󰚥"
    fi

    echo -n "${COLOR} ${ICON} ${BATTERY}% "
  fi
fi

echo "#[fg=$T_ACCENT]$DATE"
