#!/bin/bash

DOTFILES=$HOME/.dotfiles
HOMEFILES=$HOME/.dotfiles/home
CONFIGFILES=$DOTFILES/.config
SCRIPTS=$HOME/.dotfiles/scripts

#checking for correct paths
read -r -p "The path of dotfiles is set at $DOTFILES . Is this correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -r -p "What is the correct path? " path
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
read -r -p "Is this correct? [Y]es [n]o: " answer
answer=$(echo "$answer" | awk '{print tolower($0)}')

if [[ $answer == "n" || $answer == "no" ]]
then
	read -r -p "What is the correct path for SCRIPTS? [ENTER to skip]" scriptpath
	if [[ ! $scriptpath == "" ]]
	then
		SCRIPTS=$scriptpath
	fi

		read -r -p "What is the correct path for HOME FILES? [RETURN to skip]" homepath
	if [[ ! $homepath == "" ]]
	then
		HOMEFILES=$homepath
	fi

		read -r -p "What is the correct path for CONFIG FILES? [RETURN to skip]" configpath
	if [[ ! $configpath == "" ]]
	then
		CONFIGFILES=$configpath
	fi
fi

# searching for variables and adding/replacing
cntdf=$(grep -c "DOTFILES=" "$HOMEFILES/.bashrc")
if [ $cntdf -gt 0 ]
then
	echo "Updating DOTFILES global variable"
	sed -i "s|DOTFILES=.*|DOTFILES=${DOTFILES}|" "$HOMEFILES/.bashrc"
else
	echo "Creating DOTFILES global variable"
	sed -i "1i export DOTFILES=${DOTFILES}" "$HOMEFILES/.bashrc"
fi

cnthf=$(grep -c "HOMEFILES=" "$HOMEFILES/.bashrc")
if [ $cnthf -gt 0 ]
then
	echo "Updating HOMEFILES global variable"
	sed -i "s|HOMEFILES=.*|HOMEFILES=${HOMEFILES}|" "$HOMEFILES/.bashrc"
else
	echo "Creating HOMEFILES global variable"
	sed -i "1i export HOMEFILES=${HOMEFILES}" "$HOMEFILES/.bashrc"
fi

cntsc=$(grep -c "SCRIPTS=" "$HOMEFILES/.bashrc")
if [ $cntsc -gt 0 ]
then
	echo "Updating SCRIPTS global variable"
	sed -i "s|SCRIPTS=.*|SCRIPTS=${SCRIPTS}|" "$HOMEFILES/.bashrc"
else
	echo "Creating SCRIPTS global variable"
	sed -i "1i export SCRIPTS=${SCRIPTS}" "$HOMEFILES/.bashrc"
fi

cntcf=$(grep -c "CONFIGFILES=" "$HOMEFILES/.bashrc")
if [ $cntcf -gt 0 ]
then
	echo "Updating CONFIGFILES global variable"
	sed -i "s|CONFIGFILES=.*|CONFIGFILES=${CONFIGFILES}|" "$HOMEFILES/.bashrc"
else
	echo "Creating CONFIGFILES global variable"
	sed -i "1i export CONFIGFILES=${CONFIGFILES}" "$HOMEFILES/.bashrc"
fi

# DISTRO-DEPENDANT INSTALLATIONS #
pkg=$(bash "$SCRIPTS/id_pkgmgr.sh")
case $pkg in
	apt)
		bash "$SCRIPTS/setup-apt.sh"
		;;
	dnf)
		bash "$SCRIPTS/setup-dnf.sh"
		;;
	*)
		echo "No setup for package manager: $pkg"
		;;
esac

# SYMLINKS #
## bashrc
if [ -f "$HOME/.bashrc" ]  || [ -L "$HOME/.bashrc" ]
then
	mv .bashrc .bashrc_old
fi

ln -s "$HOMEFILES/.bashrc" --target-directory="$HOME"
source "$HOME/.bashrc"

## .config files
# format: "target" "subdirectory_in_.config"
SYMLINKS=(
	"bspwm" ""
	"sxhkd" ""
	"nvim" ""
)

for (( i=0;i<${#SYMLINKS[@]};i++))
do
	TARGET=$CONFIGFILES/${SYMLINKS[$i]}
	j=$((i + 1)) #fetch .config sublocation
	DIRECT=$HOME/.config/${SYMLINKS[$j]}

	#check if .config exists
	chmod +x "$TARGET"
	if [[ ! -d "$DIRECT" ]]
	then
		mkdir -p "$DIRECT"
	fi

	#check if symlink already exists (and back it up)
	if [ -d "$DIRECT/${SYMLINKS[$i]}" ] || [ -L "$DIRECT/${SYMLINKS[$i]}" ]
	then
		echo "A symlink for ${SYMLINKS[$i]} was found. Backing it up to ${SYMLINKS[$i]}_old"
		mv "$DIRECT/${SYMLINKS[$i]}" "$DIRECT/${SYMLINKS[$i]}_old"
	fi
	ln -s "$TARGET" "$DIRECT"

	#skip next i (.config sublocation)
	i=$((i + 1))
done

## Touchpad config
tpconf="30-touchpad.conf"
if [ -L /usr/share/X11/xorg.conf.d/${tpconf} ]
then
	echo "A symlink for ${tpconf} was found. Backing it up to ${tpconf}_old"
	sudo mv /usr/share/X11/xorg.conf.d/${tpconf} /usr/share/X11/xorg.conf.d/${tpconf}_old
fi
sudo ln -s "$DOTFILES/other/xorg.conf.d/30-touchpad.conf" /usr/share/X11/xorg.conf.d

# INSTALLATIONS #
## eww config
bash "$SCRIPTS/eww.sh"

## golang
bash "$SCRIPTS/go.sh"

# SETTINGS #
## Brightness without sudo
sudo chown root:root /usr/bin/brightnessctl
sudo chmod 4775 /usr/bin/brightnessctl

echo
echo "Setup done."
echo "Go to $HOME/.bashrc and check that all exported paths are correct."
