#!/usr/bin/env zsh

typeset -A nvim_pids
typeset -A pid_to_ppid

while IFS= read -r line; do
  parts=(${(z)line})

  local pid=${parts[1]}
  local ppid=${parts[2]}
  local comm=${parts[3]}

  if [[ "$comm" == "nvim" ]]; then
    nvim_pids[$pid]=1
    pid_to_ppid[$pid]=$ppid
  fi
done < <(ps -eo pid,ppid,comm --no-headers | grep nvim)

local nvim_count=0

for pid in ${(k)nvim_pids}; do
  local ppid=${pid_to_ppid[$pid]}

  if [[ -z "${nvim_pids[$ppid]}" ]]; then
    ((nvim_count++))
  fi
done

local docker_count
docker_count=$(docker ps -q 2>/dev/null | wc -l)

[[ $nvim_count -eq 0 && $docker_count -eq 0 ]] && exit 0

local text=""


if [[ $nvim_count -gt 0 ]]; then
  text+="<span color='#39FF14'></span><sub><b>$nvim_count</b></sub>"
fi

if [[ $docker_count -gt 0 ]]; then
  [[ -n "$text" ]] && text+=" "
  text+="<span color='#2496ED'></span><sub><b>$docker_count</b></sub>"
fi

jq -cn \
  --arg text "$text" \
  '{text: $text}'
