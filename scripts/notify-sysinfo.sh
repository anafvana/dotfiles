#!/bin/bash
notify-send -t 2000 -h string:x-canonical-private-synchronous:sysinfo "Sysinfo" "\n$(date +"%A %d %B %Y %H:%M:%S")\n$(acpi |
grep "harging" |
sed "s/Battery\ 0\:\ //g" |
sed "s/Battery\ 1\:\ //g")"
