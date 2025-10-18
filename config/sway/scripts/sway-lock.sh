#/usr/bin/bash

pidof swaylock && exit 0

pidof 1password && 1password --lock

swaylock -f
