#!/usr/bin/env sh

set -eu

STATE_DIR=${XDG_RUNTIME_DIR:-/tmp}
STATE_FILE="$STATE_DIR/waybar-network-stats"

first_default_iface() {
  ip -o route show default 2>/dev/null | awk '
    NR == 1 {
      for (i = 1; i <= NF; i++) {
        if ($i == "dev") {
          print $(i + 1)
          exit
        }
      }
    }'
}

first_up_iface() {
  for path in /sys/class/net/*; do
    iface=${path##*/}
    [ "$iface" = "lo" ] && continue
    state=$(cat "$path/operstate" 2>/dev/null || printf 'down')
    case "$state" in
      up|unknown)
        printf '%s\n' "$iface"
        return 0
        ;;
    esac
  done
  return 1
}

get_ip() {
  iface=$1
  ip -o -4 addr show dev "$iface" 2>/dev/null | awk 'NR == 1 {print $4}' | cut -d/ -f1
}

read_counter() {
  file=$1
  cat "$file" 2>/dev/null || printf '0'
}

format_rate() {
  bytes_per_sec=${1:-0}
  awk -v bps="$bytes_per_sec" '
    function human(v) {
      if (v >= 1073741824) return sprintf("%.1f GiB/s", v / 1073741824)
      if (v >= 1048576) return sprintf("%.1f MiB/s", v / 1048576)
      if (v >= 1024) return sprintf("%.1f KiB/s", v / 1024)
      return sprintf("%d B/s", v)
    }
    BEGIN { print human(bps) }'
}

bandwidth_rates() {
  iface=$1
  rx_now=$(read_counter "/sys/class/net/$iface/statistics/rx_bytes")
  tx_now=$(read_counter "/sys/class/net/$iface/statistics/tx_bytes")
  now=$(date +%s)

  rx_rate=0
  tx_rate=0

  if [ -f "$STATE_FILE" ]; then
    old_line=$(grep "^$iface " "$STATE_FILE" 2>/dev/null | tail -n 1 || true)
    if [ -n "$old_line" ]; then
      old_ts=$(printf '%s\n' "$old_line" | awk '{print $2}')
      old_rx=$(printf '%s\n' "$old_line" | awk '{print $3}')
      old_tx=$(printf '%s\n' "$old_line" | awk '{print $4}')
      delta=$((now - old_ts))
      if [ "$delta" -gt 0 ]; then
        rx_delta=$((rx_now - old_rx))
        tx_delta=$((tx_now - old_tx))
        [ "$rx_delta" -ge 0 ] || rx_delta=0
        [ "$tx_delta" -ge 0 ] || tx_delta=0
        rx_rate=$((rx_delta / delta))
        tx_rate=$((tx_delta / delta))
      fi
    fi
  fi

  tmp_file="$STATE_FILE.$$"
  {
    if [ -f "$STATE_FILE" ]; then
      grep -v "^$iface " "$STATE_FILE" 2>/dev/null || true
    fi
    printf '%s %s %s %s\n' "$iface" "$now" "$rx_now" "$tx_now"
  } > "$tmp_file"
  mv "$tmp_file" "$STATE_FILE"

  printf '%s\n%s\n' "$(format_rate "$tx_rate")" "$(format_rate "$rx_rate")"
}

is_wifi() {
  [ -d "/sys/class/net/$1/wireless" ]
}

is_cellular() {
  case "$1" in
    wwan*|rmnet*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

wifi_ssid() {
  iface=$1
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -t -f GENERAL.CONNECTION device show "$iface" 2>/dev/null | sed -n 's/^GENERAL.CONNECTION://p' | head -n 1
  elif command -v iwgetid >/dev/null 2>&1; then
    iwgetid -r "$iface" 2>/dev/null || true
  fi
}

wifi_bssid() {
  iface=$1
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -t -f 802-11-wireless.bssid device show "$iface" 2>/dev/null | sed -n 's/^802-11-wireless.bssid://p' | head -n 1
  elif command -v iwgetid >/dev/null 2>&1; then
    iwgetid -a -r "$iface" 2>/dev/null || true
  fi
}

mmcli_info_for_iface() {
  iface=$1
  command -v mmcli >/dev/null 2>&1 || return 1

  for modem in $(mmcli -L 2>/dev/null | sed -n 's@.*/Modem/\([0-9][0-9]*\).*@\1@p'); do
    info=$(mmcli -m "$modem" 2>/dev/null || true)
    [ -n "$info" ] || continue

    if printf '%s\n' "$info" | grep -Eq "ports:.*(^|[ ,])$iface \(net\)"; then
      printf '%s\n' "$info"
      return 0
    fi

    if printf '%s\n' "$info" | grep -Eq "primary port:[[:space:]]*$iface([[:space:]]|$)"; then
      printf '%s\n' "$info"
      return 0
    fi
  done

  return 1
}

cellular_generation() {
  iface=$1
  info=$(mmcli_info_for_iface "$iface" || true)
  tech=$(printf '%s\n' "$info" | sed -n 's/.*access tech:[[:space:]]*//p' | head -n 1)
  tech=$(printf '%s' "$tech" | tr '[:upper:]' '[:lower:]')

  case "$tech" in
    *5gnr*|*nr5g*|*5g*|*nr*)
      printf '5G'
      ;;
    *lte*)
      printf '4G'
      ;;
    *umts*|*hspa*|*hsupa*|*hsdpa*|*evdo*|*1xrtt*)
      printf '3G'
      ;;
    *edge*|*gprs*|*gsm*)
      printf '2G'
      ;;
    *)
      printf 'Cellular'
      ;;
  esac
}

cellular_operator() {
  iface=$1
  info=$(mmcli_info_for_iface "$iface" || true)
  printf '%s\n' "$info" | sed -n 's/.*operator name:[[:space:]]*//p' | head -n 1
}

cellular_signal_quality() {
  iface=$1
  info=$(mmcli_info_for_iface "$iface" || true)
  printf '%s\n' "$info" | sed -n 's/.*signal quality:[[:space:]]*\([0-9][0-9]*\)%.*/\1/p' | head -n 1
}

cellular_icon() {
  quality=${1:-}
  case "$quality" in
    ''|*[!0-9]*)
      printf "<span color='#f8f8f2'>󰤯</span>"
      ;;
    9[0-9]|100)
      printf "<span color='#69ff94'>󰤨</span>"
      ;;
    7[0-9]|8[0-9])
      printf "<span color='#2aa9ff'>󰤥</span>"
      ;;
    5[0-9]|6[0-9])
      printf "<span color='#ffffa5'>󰤢</span>"
      ;;
    3[0-9]|4[0-9])
      printf "<span color='#ff9977'>󰤟</span>"
      ;;
    *)
      printf "<span color='#dd532e'>󰤠</span>"
      ;;
  esac
}

iface=$(first_default_iface || true)
if [ -z "${iface:-}" ]; then
  iface=$(first_up_iface || true)
fi

if [ -z "${iface:-}" ]; then
  jq -cnc '{text:"<span color=\"#FF4040\">󰤮</span> --", tooltip:"Disconnected", class:"disconnected"}'
  exit 0
fi

ip_addr=$(get_ip "$iface" || true)
state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null || printf 'down')
rates=$(bandwidth_rates "$iface")
tx_rate=$(printf '%s\n' "$rates" | sed -n '1p')
rx_rate=$(printf '%s\n' "$rates" | sed -n '2p')

if is_wifi "$iface"; then
  ssid=$(wifi_ssid "$iface")
  bssid=$(wifi_bssid "$iface")
  label=$ssid
  [ -n "$label" ] || label=$bssid
  [ -n "$label" ] || label=$iface
  text="<span color='#00FFFF'>󰤨</span> $label"
  tooltip="$iface${ip_addr:+ - $ip_addr}  <span color='#FF1493'>󰅧</span> $tx_rate  <span color='#00BFFF'>󰅢</span> $rx_rate"
  alt="$label${ip_addr:+ - $ip_addr}  <span color='#FF1493'>󰅧</span> $tx_rate  <span color='#00BFFF'>󰅢</span> $rx_rate"
  class="wifi"
elif is_cellular "$iface"; then
  generation=$(cellular_generation "$iface")
  operator=$(cellular_operator "$iface")
  quality=$(cellular_signal_quality "$iface")
  icon=$(cellular_icon "$quality")
  label=$operator
  if [ -n "$label" ] && [ "$generation" != "Cellular" ]; then
    label="$label $generation"
  elif [ -z "$label" ]; then
    label=$generation
  fi
  text="$icon $label"
  tooltip="$iface"
  [ -n "$operator" ] && tooltip="$tooltip - $operator"
  [ -n "$quality" ] && tooltip="$tooltip - $quality%"
  [ -n "$ip_addr" ] && tooltip="$tooltip - $ip_addr"
  tooltip="$tooltip  <span color='#FF1493'>󰅧</span> $tx_rate  <span color='#00BFFF'>󰅢</span> $rx_rate"
  alt="$label${quality:+ - $quality%}${ip_addr:+ - $ip_addr}  <span color='#FF1493'>󰅧</span> $tx_rate  <span color='#00BFFF'>󰅢</span> $rx_rate"
  class="cellular"
elif [ "$state" = "up" ] || [ "$state" = "unknown" ]; then
  text="<span color='#7FFF00'> </span> Wired"
  tooltip="$iface${ip_addr:+ - $ip_addr}  <span color='#FF1493'>󰅧</span> $tx_rate  <span color='#00BFFF'>󰅢</span> $rx_rate"
  alt="$iface${ip_addr:+ - $ip_addr}  <span color='#FF1493'>󰅧</span> $tx_rate  <span color='#00BFFF'>󰅢</span> $rx_rate"
  class="ethernet"
else
  text="<span color='#FFA500'>󱘖 </span>$iface"
  tooltip="$iface"
  alt="$iface"
  class="linked"
fi

jq -cn \
  --arg text "$text" \
  --arg alt "$alt" \
  --arg tooltip "$tooltip" \
  --arg class "$class" \
  '{text:$text, alt:$alt, tooltip:$tooltip, class:$class}'
