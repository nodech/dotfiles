#!/usr/bin/env bash

[[ ! -d $1 ]] && echo "Could not find directory: \"$1\"" && exit 1

# Started from: https://stackoverflow.com/a/545413/3607360
files=`find $1 -type f | sort | grep -v \/.git\/`

if [[ -f ~/.gitignore_global ]]; then
  #echo "Filtering with global gitignore"
  files=`echo "$files" | grep -vFf ~/.gitignore_global`
fi

# Only works if the directory itself has .gitignore
# It does not do it recursively. good enough for now
if [[ -f $1/.gitignore ]]; then
  #echo "Filtering with $1/.gitignore"

  # removes empty lines
  gitignore=`cat $1/.gitignore | sed '/^$/d'`
  files=`echo "$files" | grep -vFf <(echo "$gitignore")`
fi

allHashes=`echo "$files" | xargs sha1sum`

finalHash=`echo $allHashes | sha1sum`
echo "$finalHash \"$1\""
