#!/usr/bin/env bash

if [[ -z "$1" || ! -d "$1" ]]; then
  printf 'error: directory not found: "%s"\n' "$1" >&2
  exit 1
fi

allHashes=$(
  cd "$1" &&
  LC_ALL=C fd -H -t f -0 \
    | xargs -0 sha1sum \
    | sort 
)


printf '%s\n' "$allHashes" | sha1sum
