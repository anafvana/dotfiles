#!/bin/bash

LANG=`setxkbmap -print -verbose 7 | grep "layout" | sed -e "s/layout:     //"`

notify-send -t 2000 -h string:x-canonical-private-synchronous:langinfo "$LANG" ""
