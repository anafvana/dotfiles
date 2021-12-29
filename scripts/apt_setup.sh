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
sudo apt install -y bspwm sxhkd dunst brightnessctl alsa-utils acpi scrot alacritty feh

### pywal
sudo apt install -y python3.9 python3-pip imagemagick procps
sudo pip3 install pywal

## Additional setup packages
sudo apt install git curl tree silversearcher-ag

### neovim
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

### spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/spotify.gpg --import
sudo chown _apt /etc/apt/trusted.gpg.d/spotify.gpg
sudo apt install spotify-client

### insync
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

sudo apt update && sudo apt upgrade -y

# GENERAL SETUP (continue) #
chmod +x $SCRIPTS/setup.sh
bash $SCRIPTS/setup.sh
