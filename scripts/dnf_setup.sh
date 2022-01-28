#!/bin/bash

if [[ $SCRIPTS == "" ]]
then
	SCRIPTS=$HOME/.dotfiles/scripts
fi

read -p "Your scripts folder is defined as \"$SCRIPTS\". Is that correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -p "What is the correct path? " path
	SCRIPTS=$path
fi

# PACKAGES
## Basic setup packages
sudo dnf install -y bspwm sxhkd dunst brightnessctl alsa-utils acpi scrot alacritty feh redshift

### pywal
sudo dnf install -y python3.9 python3-pip.noarch ImageMagick procps
sudo pip3 install pywal

## Additional setup packages
sudo dnf install -y git curl tree the_silver_searcher neovim flatpak

### spotify
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub com.spotify.Client

### signal
sudo flatpak install flathub org.signal.Signal

### insync
{
	curl -o $HOME/insync.rpm https://d2t3ff60b2tol4.cloudfront.net/builds/insync-3.7.0.50216-fc35.x86_64.rpm && sudo rpm -i $HOME/insync.rpm && rm $HOME/insync.rpm
} || {
	echo "Insync installation failed"

	read -p "Would you like to remove downloaded files? [Y]es [n]o: " answer
	answer=$(echo "$answer" | awk '{print tolower($0)}')
	if [[ $answer == "n" || $answer == "no" ]]
	then
		echo "Check $HOME/insync.rpm for downloaded Insync file"
	else
		rm $HOME/insync.rpm
		echo "Files removed."
	fi
	echo "Continuing..."
}

sudo dnf update -y
