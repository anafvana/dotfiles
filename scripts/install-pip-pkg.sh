#!/bin/bash

if (( $# != 1 ))
then
    >&2 echo "Illegal number of arguments. Must be exactly 1"
	exit 1
fi

pkg=$1
pkgExists=`echo $(type "$pkg" 2>&1)`


if ! [[ $pkgExists =~ "not found" ]]
then
	echo "$pkg is already installed"
	exit 0
fi

#pip install "$pkg"

answer="none"

while [[ true ]]
do
	case "$answer" in
		"n"|"no"|"")
			break ;;
		"y"|"yes")
			echo "Tough luck, someone was lazy and didn't implement this feature"
			break ;;
		*)
			read -r -p "Do you want to link this package's binaries to /usr/local/bin ? [y]es [N]o: " answer
			answer=$(echo "$answer" | awk '{print tolower($0)}') ;;
	esac
done

echo "\"$answer\""
