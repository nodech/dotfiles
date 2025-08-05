#!/usr/bin/env bash

while true; do
    swaymsg -t subscribe '["output"]'
    $XDG_CONFIG_HOME/sway/scripts/sway-monabove.sh
done
