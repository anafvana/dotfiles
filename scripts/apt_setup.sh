#!/bin/bash

SCRIPTS=$HOME/.dotfiles/scripts

read -p "Your scripts folder is defined as \"$HOME/.dotfiles/scripts\". Is that correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -p "What is the correct path? " path
	SCRIPTS=$path
fi

# PACKAGES
## Basic setup packages
sudo apt install -y bspwm sxhkd dunst brightnessctl alsa-utils acpi scrot alacritty

## Additional setup packages
#neovim
sudo add-apt-repository -y ppa:neovim-ppa/unstable

#spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/spotify.gpg --import
sudo chown _apt /etc/apt/trusted.gpg.d/spotify.gpg

sudo apt-get update

sudo apt install git curl neovim tree silversearcher-ag spotify-client

sudo apt update && sudo apt upgrade -y

#insync
{
	curl -o $HOME/insync.deb https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.6.1.50206-impishh_amd64.deb && sudo dpkg -i $HOME/insync.deb && rm $HOME/insync.deb
} || {
	echo "Insync installation failed"

	read -p "Would you like to remove downloaded files? [Y]es [n]o: " answer
	answer=$(echo "$answer" | awk '{print tolower($0)}')
	if [[ $answer == "n" || $answer == "no" ]]
	then
		echo "Check $HOME/insync.deb for downloaded Insync file"
	else
		rm $HOME/insync.deb
		echo "Files removed."
	fi
	echo "Continuing..."
}

# GENERAL SETUP (continue) #
chmod +x $SCRIPTS/setup.sh
bash $SCRIPTS/setup.sh
