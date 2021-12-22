#!/bin/bash

DOTFILES=$(echo `pwd` | sed "s/\/scripts//")
SCRIPTS=$(echo `pwd`)

# SETTINGS
## Brightness without sudo
sudo chown root:root /usr/bin/brightnessctl
sudo chmod 4775 /usr/bin/brightnessctl

# SYMLINKS
## bashrc
ln -s $DOTFILES/.bashrc $HOME

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
