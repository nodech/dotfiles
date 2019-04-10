#!/usr/bin/env bash

# Terminate already running bar instances
killall -q dunst

# Wait until the processes have been shut down
while pgrep -u $UID -x dunst >/dev/null; do sleep 1; done

# Launch bar1 and bar2
dunst &

echo "Bars launched..."

