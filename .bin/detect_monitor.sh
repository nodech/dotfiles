#!/bin/bash
# Thanks ChatGPT.

get_geometry_by_monitor() {
  local monitor_name=$1

  # Use xrandr to find the monitor's geometry
  local monitor_info=$(xrandr | grep "^$monitor_name connected")
  if [[ -z "$monitor_info" ]]; then
    echo "Monitor \"$monitor_name\" not found or not connected."
    exit 1
  fi

  # Extract the geometry
  local geometry=$(echo "$monitor_info" | grep -oP "\d+x\d+\+\d+\+\d+")
  echo "$geometry"
}


get_mouse_monitor() {
  # Get mouse location
  mouse_coords=$(xdotool getmouselocation --shell)
  mouse_x=$(echo "$mouse_coords" | grep X= | cut -d= -f2)
  mouse_y=$(echo "$mouse_coords" | grep Y= | cut -d= -f2)

  # Get monitor layout from xrandr
  xrandr | grep " connected" | while read -r line; do
      monitor=$(echo "$line" | cut -d' ' -f1)
      geometry=$(echo "$line" | grep -oP "\d+x\d+\+\d+\+\d+")
      width=$(echo "$geometry" | cut -dx -f1)
      height=$(echo "$geometry" | cut -dx -f2 | cut -d+ -f1)
      offset_x=$(echo "$geometry" | cut -d+ -f2)
      offset_y=$(echo "$geometry" | cut -d+ -f3)

      if (( mouse_x >= offset_x && mouse_x < offset_x + width &&
            mouse_y >= offset_y && mouse_y < offset_y + height )); then
          echo "$monitor"
          break
      fi
  done
}

command=$1

case $command in
  monitor)
    get_mouse_monitor
    ;;
  geometry)
    monitor_name=$2
    get_geometry_by_monitor "$monitor_name"
    ;;
  getactivegeometry)
    monitor_name=$(get_mouse_monitor)
    get_geometry_by_monitor "$monitor_name"
    ;;
  *)
    echo "Invalid command: $command"
    echo "Usage: $0 {monitor|geometry output|getactivegeometry}"
    exit 1
    ;;
esac
