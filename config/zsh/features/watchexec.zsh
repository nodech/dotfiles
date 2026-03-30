watchex() {
  local exts=$1
  shift
  watchexec -e "$exts" --clear --restart --stdin-quit "$@"
}

watchjs() {
  watchex js,jsx,ts,tsx,mjs "$@"
}

watchgo() {
  watchex go "$@"
}

watchrust() {
  watchex rs "$@"
}

watchc() {
  watchex c,h,cc,hh "$@"
}

watchpy() {
  watchex py "$@"
}
