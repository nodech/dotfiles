#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

i=1
for m in $(polybar --list-monitors | cut -d":" -f1); do
  echo polybar --config=$HOME/.config/polybar/config-$i node &
  MONITOR=$m polybar --config=$HOME/.config/polybar/config-$i node &
  i=$((i + 1))
done

echo "Bars launched..."
