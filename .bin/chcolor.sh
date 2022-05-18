#!/bin/bash

CONFIG_DIR=$HOME/.config/nod
VIM_DIR=$HOME/.config/nvim/configs

## .config/nod configs
##   alacritty/template.yml
##   alacritty.sh - font configs
##   themes/themes-dir/alacritty.yml
##   themes/themes-dir/

THEMES_DIR="${CONFIG_DIR}/themes"

ALA_CONFIG_FILE="${CONFIG_DIR}/alacritty.sh"
ALA_COLORS_DIR="${CONFIG_DIR}/alacritty/colors"
ALA_TEMPLATE="${CONFIG_DIR}/alacritty/template.yml"

source $ALA_CONFIG_FILE

help() {
  echo "chcolor.sh [-lh] color"
}

list() {
  files=`ls ${THEMES_DIR}`

  echo "Showing colors.."
  for f in $files
  do
    dir="${THEMES_DIR}/$f"
    echo -n "  $f";
    if [[ -f "$dir/alacritty.yml" ]]
    then
      echo -n " (alacritty)"
    fi

    if [[ -f "$dir/colorconf.vimrc" && -f "$dir/colorplug.vimrc" ]]
    then
      echo -n " (vimrc)"
    fi
    echo 
  done
}

generate_ala() {
  colors_dir="${THEMES_DIR}/$1"

  if [[ ! -f "$colors_dir/alacritty.yml" ]]
  then
    echo "Missing alacritty module for '$1'"
    exit 0
  fi

  export COLORS=`cat ${colors_dir}/alacritty.yml`

  echo "Generating ~/.alacritty.yml..."
  export FONT_SIZE=$ALA_FONT_SIZE
  envsubst < $ALA_TEMPLATE > $HOME/.alacritty.yml

  echo "Generating ~/.alacritty.hdmi.html..."
  export FONT_SIZE=$ALA_FONT_SIZE_HDMI
  envsubst < $ALA_TEMPLATE > $HOME/.alacritty.hdmi.yml

}

generate_vim() {
  colors_dir="${THEMES_DIR}/$1"

  src_plug="$colors_dir/colorplug.vimrc"
  src_conf="$colors_dir/colorconf.vimrc"
  vim_plug="$VIM_DIR/colorplug.vimrc"
  vim_conf="$VIM_DIR/colorconf.vimrc"

  if [[ -f "$src_plug" && -f "$src_conf" ]]
  then
    echo "Removing vim configs..."
    rm $vim_plug
    rm $vim_conf
    echo "Relinking vim configs..."
    ln -s $src_plug $vim_plug
    ln -s $src_conf $vim_conf
    exit 0
  fi

  echo "Missing VIM module for '$1'."
}

generate() {
  colors_dir="${THEMES_DIR}/$1"

  if [[ ! -d "$colors_dir" ]]
  then
    echo "Color '$1' not found, chcek list with"
    echo "  chcolor.sh -l"
    exit 1
  fi

  generate_ala $1
  generate_vim $1
  exit 0
}

for i in "$@"
do
  case $i in
    -l)
      echo "Showing list of colors.."
      list
      exit 1
      ;;
    -h)
      help
      exit 1
      ;;
    *)
      generate "$i"
      exit $?
      ;;
  esac
done

help
