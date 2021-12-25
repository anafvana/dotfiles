#!/bin/bash

DOTFILES=$HOME/.dotfiles
SCRIPTS=$HOME/.dotfiles/scripts

#checking for correct paths
read -p "The path of dotfiles is set at $DOTFILES . Is this correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -p "What is the correct path? " path
	DOTFILES=$path
	SCRIPTS=$DOTFILES/scripts
fi

read -p "The path of scripts is set at $SCRIPTS . Is this correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -p "What is the correct path? " path
	SCRIPTS=$DOTFILES/scripts
fi

# SETTINGS #
## Brightness without sudo
sudo chown root:root /usr/bin/brightnessctl
sudo chmod 4775 /usr/bin/brightnessctl

# SYMLINKS #
## bashrc
if [ -f $HOME/.bashrc ]
then
	mv .bashrc .bashrc_old
fi

#TODO Correct $DOTFILES and $SCRIPTS if not default

ln -s $DOTFILES/.bashrc --target-directory=$HOME
# source $HOME/.bashrc #TODO uncomment when todo above is completed

## .config files
# format: targetFile directory
SYMLINKS=(
	"bspwmrc" ".config/bspwm"
	"sxhkdrc" ".config/sxhkd"
	"nvim" ".config"
)

for (( i=0;i<${#SYMLINKS[@]};i++))
do
	TARGET=$DOTFILES/${SYMLINKS[$i]}
	i=$(($i+1))
	DIRECT=$HOME/${SYMLINKS[$i]}

	chmod +x "$TARGET"
	if [[ ! -d "$DIRECT" ]]
	then
		mkdir -p "$DIRECT"
	fi
	ln -s "$TARGET" "$DIRECT"
done

## Touchpad config
sudo ln -s $DOTFILES/xorg.conf.d/30-touchpad.conf /usr/share/X11/xorg.conf.d

# INSTALLATIONS #
## eww config
bash $SCRIPTS/eww.sh

## golang
bash $SCRIPTS/go.sh

echo
echo "Setup done."
echo "Go to $HOME/.bashrc and check that all exported paths are correct."
exit 0
