#!/bin/bash

#This is a temporary script to supply for eww's absence in most package managers. Check https://elkowar.github.io/eww/eww.html to make sure this is still the ideal procedure

declare PKGMGR

options=($(ls /etc/ | grep -E '(release|version)$'))
for opt in ${options[@]}
do
	case $opt in
		debian_version)
			PKGMGR="apt"
			break
			;;
		redhat-release)
			PKGMGR="dnf"
			break
			;;
		arch-release)
			PKGMGR="pacman"
			break
			;;
		gentoo-release)
			PKGMGR="emerge"
			break
			;;
		SuSE-release)
			PKGMGR="zypp"
			break
			;;
		*)
			echo "Could not identify package manager"
			return
			;;
	esac
done

echo $PKGMGR
