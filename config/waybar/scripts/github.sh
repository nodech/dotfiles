#!/bin/bash

count=$(gh api notifications | jq '. | length')

if [[ "$count" != "0" ]]; then
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
fi
