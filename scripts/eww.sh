#!/bin/bash

#This is a temporary script to supply for eww's absence in most package managers. Check https://elkowar.github.io/eww/eww.html to make sure this is still the ideal procedure

declare PKGMGR

# package manager can be passed as an argument or automatically identified
if [ "$#" -eq 1 ]
then
	PKGMGR=$1
else
	PKGMGR=$(chmod +x $SCRIPTS/id_pkgmgr.sh ; $SCRIPTS/id_pkgmgr.sh)
fi

# core installation task
runInstaller(){
	# install rust
	echo "Installing Rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	# restart shell to add cargo to path
	source $HOME/.bash_profile
	source $HOME/.bashrc
	. "$HOME/.cargo/env" #necessary due to placement in .bashrc
	rustup update

	# install other dependencies according to package manager
	case $PKGMGR in
		apt)
			sudo apt install -y libgtk-3-dev libpango1.0-dev libgdk-pixbuf2.0-dev libcairo-5c-dev libcairo-gobject2 libglib2.0-dev gcc
			sudo apt update; sudo apt upgrade -y
			;;
		*)
		echo "Could not identify correct installation settings"
		return
		;;
	esac

	currDir=$(pwd)
	cd $OTHER
	git clone https://github.com/elkowar/eww
	cd eww
	cargo build --release
	chmod +x target/release/eww
	ln -s $OTHER/eww/target/release/eww $BINARIES
	cd $currDir

}

# present warning and handle input
read -p $'WARNING: eww\'s installation process might have been updated.\nAre you sure you want to continue? [y]es [N]o [d]ocs: ' answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "y" || $answer == "yes" ]]
then
	runInstaller
elif [[ $answer == "d" || $answer == "docs" ]]
then
	# open eww's documentation link and prompt user to decide again
	xdg-open https://elkowar.github.io/eww/eww.html
	read -p "Would you like to continue? [y]es [N]o: " proceed
	proceed=$(echo "$proceed" | awk '{print tolower($0)}')
	if [[ $proceed == "y" || $proceed == "yes" ]]
	then
		runInstaller
	else
		exit 1
	fi
else
	exit 1
fi
