watchex() {
  watchexec -e $1 --clear --restart --stdin-quit ${@:2}
}

watchjs() {
  watchex js,jsx,ts,tsx,mjs $@
}

watchgo() {
  watchex go $@
}

watchrust() {
  watchex rs $@
}

watchc() {
  watchex c,h,cc,hh $@
}

watchpy() {
  watchex py $@
}
