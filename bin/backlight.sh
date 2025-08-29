#! /bin/sh
#

KERNEL=`uname -s`
DEVICE="intel_backlight"
BRIGHTNESS=/sys/class/backlight/$DEVICE/brightness
MAX_BRIGHTNESS=/sys/class/backlight/$DEVICE/max_brightness
min_brightness_p=1


if [[ "$KERNEL" != "Linux" ]]; then
  echo "This is linux based script."
  exit 2
fi

if [[ ! -f $BRIGHTNESS ]]; then
  echo "Could not find backlight device \"$DEVICE\""
  exit 2
fi

if [[ ! -w $BRIGHTNESS ]]; then
  echo "Do not have write permission to $BRIGHTNESS"
  echo "Note:"
  echo " Make sure you have enabled udev rules and you are"
  echo " part of the group."
  exit 2
fi

usage() {
  echo "Usage: backlight [[+/-]PERCENT]"
}

get_current_brightness() {
  cat $BRIGHTNESS
}

get_max_brigtness() {
  cat $MAX_BRIGHTNESS
}

get_brightness_p() {
  echo $(( `cat $BRIGHTNESS` * 100 / `cat $MAX_BRIGHTNESS` ))
}

set_brightness() {
  echo $1 > $BRIGHTNESS
}

set_brightness_p() {
  local percent=$1

  [[ $percent -gt 100 || $percent -lt $min_brightness_p ]] && exit 1

  local max_brightness=$(get_max_brigtness)

  set_brightness $(( $percent * $max_brightness / 100 ))
}

increase_brightness_p() {
  local increase=$1

  [[ $increase -gt 100 || $increase -lt 0 ]] && exit 1

  local current=$(get_brightness_p)
  local new=$(( $current + $increase ))

  set_brightness_p $new
}

decrease_brightness_p() {
  local decrease=$1

  [[ $decrease -gt 100 || $decrease -lt 0 ]] && exit 1

  local current=$(get_brightness_p)
  local new=$(( $current - $decrease ))

  set_brightness_p $new
}

PERCENT=$1

if [[ "$PERCENT" == "-h" ]]; then
  usage
  exit 1
fi

if [[ "$PERCENT" == "" ]]; then
  get_brightness_p
  exit 0
fi

if [[ "$PERCENT" == +* ]]; then
  increase_brightness_p ${PERCENT#+}
  exit 1
fi

if [[ "$PERCENT" == -* ]]; then
  decrease_brightness_p ${PERCENT#-}
  exit 0
fi

if [[ $PERCENT -gt 100 || $PERCENT -lt 0 ]]; then
  echo "Incorrect percent."
  exit 1
fi

set_brightness_p $PERCENT

