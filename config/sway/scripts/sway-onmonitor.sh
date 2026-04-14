#!/usr/bin/env bash

while true; do
    swaymsg -t subscribe '["output"]' || exit 1

    $XDG_CONFIG_HOME/sway/scripts/sway-monabove.sh
done
