#!/bin/bash
DIR=$1

LANG=`setxkbmap -print -verbose 7 | grep "layout" | sed -e "s/layout:     //"`
langs=("br" "us" "no")
langsLen=`expr ${#langs[@]} - 1`

if [[ $DIR == "back" ]]; then
    for (( i=$langsLen; i>=0; i-- ))
    do
        if [[ $i == 0 ]]; then
            setxkbmap ${langs[langsLen]}
            break
        elif [[ $LANG == ${langs[i]} ]]; then
            setxkbmap ${langs[i-1]}
            break
        fi
    done
else
    for (( i=0; i<=langsLen; i++ ))
    do
        if [[ $i == $langsLen ]]; then
            setxkbmap ${langs[0]}
            break
        elif [[ $LANG == ${langs[i]} ]]; then
            setxkbmap ${langs[i+1]}
            break
        fi
    done
fi

bash $SCRIPTS/notify-lang.sh
