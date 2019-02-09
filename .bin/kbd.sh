#!/bin/bash

set -e

toggle() {
  local current=$(setxkbmap -query | awk '/layout/{print $2}')
  local next="us"

  case "$current" in
    "ge")
      next="us"
      ;;
    "us")
      next="ge"
      ;;
  esac

  setxkbmap -layout $next
}

toggle
