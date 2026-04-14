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

local watchexec_count
watchexec_count=$(pgrep -c watchexec 2>/dev/null)
watchexec_count=${watchexec_count:-0}

local sms_count
sms_count=$(sms list --no-header --unread 2>/dev/null | wc -l)
sms_count=${sms_count:-0}

typeset -A counts
typeset -A icons
typeset -A colors

# collect counts...
counts[nvim]=$nvim_count
counts[docker]=$docker_count
counts[watchexec]=$watchexec_count
counts[sms]=$sms_count

icons[nvim]=''
icons[docker]=''
icons[watchexec]='󰦖'
icons[sms]='󰍦'

colors[nvim]='#39FF14'
colors[docker]='#2496ED'
colors[watchexec]='#FF8C00'
colors[sms]='#34C759'

local text=""

for name in nvim docker watchexec sms; do
  local count=${counts[$name]:-0}
  (( count > 0 )) || continue

  [[ -n "$text" ]] && text+=" "
  text+="<span color='${colors[$name]}'>${icons[$name]}</span><sub><b>${count}</b></sub>"
done

[[ -z "$text" ]] && exit 0

jq -cn \
  --arg text "$text" \
  '{text: $text}'
