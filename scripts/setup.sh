#!/bin/bash

DOTFILES=$HOME/.dotfiles
HOMEFILES=$HOME/.dotfiles/home
CONFIGFILES=$DOTFILES/.config
SCRIPTS=$HOME/.dotfiles/scripts

#checking for correct paths
read -p "The path of dotfiles is set at $DOTFILES . Is this correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -p "What is the correct path? " path
	DOTFILES=$path
	HOMEFILES=$DOTFILES/home
	CONFIGFILES=$DOTFILES/.config
	SCRIPTS=$DOTFILES/scripts
fi

echo "The following paths within THIS GIT REPOSITORY have been set:"
sleep 1
echo "Scripts: $SCRIPTS"
sleep 1
echo "Home files: $HOMEFILES"
sleep 1
echo "Config files: $CONFIGFILES"
sleep 1
read -p  "Is this correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -p "What is the correct path for SCRIPTS? [RETURN to skip]" scriptpath
	if [[ ! $scriptpath == "" ]]
	then
		SCRIPTS=$scriptpath
	fi

		read -p "What is the correct path for HOME FILES? [RETURN to skip]" homepath
	if [[ ! $homepath == "" ]]
	then
		HOMEFILES=$homepath
	fi

		read -p "What is the correct path for CONFIG FILES? [RETURN to skip]" configpath
	if [[ ! $configpath == "" ]]
	then
		CONFIGFILES=$configpath
	fi
fi


sed "s|var=.*|DOTFILES=${DOTFILES}|" $DOTFILES/.bashrc 
sed "s|var=.*|HOMEFILES=${HOMEFILES}|" $DOTFILES/.bashrc
sed "s|var=.*|SCRIPTS=${SCRIPTS}|" $DOTFILES/.bashrc 
sed "s|var=.*|CONFIGFILES=${CONFIGFILES}|" $DOTFILES/.bashrc 

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

ln -s $DOTFILES/home/.bashrc --target-directory=$HOME
source $HOME/.bashrc

## .config files
# format: targetFile directory
SYMLINKS=(
	"bspwm" ".config"
	"sxhkd" ".config"
	"nvim" ".config"
)

for (( i=0;i<${#SYMLINKS[@]};i++))
do
	TARGET=$CONFIGFILES/${SYMLINKS[$i]}
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
sudo ln -s $DOTFILES/other/xorg.conf.d/30-touchpad.conf /usr/share/X11/xorg.conf.d

# INSTALLATIONS #
## eww config
bash $SCRIPTS/eww.sh

## golang
bash $SCRIPTS/go.sh

echo
echo "Setup done."
echo "Go to $HOME/.bashrc and check that all exported paths are correct."
exit 0
