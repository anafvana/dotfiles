#!/bin/sh

scrot -s -f -o "/tmp/image.png" && xclip -selection clipboard -t image/png -i /tmp/image.png
