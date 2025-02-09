#!/bin/bash

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
			PKGMGR="FAILED TO IDENTIFY"
			;;
	esac
done

echo $PKGMGR
