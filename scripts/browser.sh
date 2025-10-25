#!/bin/bash

query=$(
  rofi -dmenu -p "" \
    -theme /home/tanvir/.config/rofi/config.rasi \
    -theme-str '
  
inputbar{
  enabled: true;
}
window {
    location: north;
    anchor: north;
    width: 50%;
    height: 30px;
    y-offset: -35px;
}
listview {
    lines: 5;
    fixed-height: true;
}

'

      
)

[ -z "$query" ] && exit 1

encoded_query=$(echo "$query" | sed 's/ /+/g')
url="https://www.google.com/search?q=$encoded_query"

~/mercury/mercury "$url" &

