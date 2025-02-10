#!/bin/bash

# HANDLE DOTFILES PATH #
DOTFILES=$HOME/.dotfiles
# Derived variables (assigned after path is confirmed): $CONFIGFILES, $HOMEFILES, $SCRIPTS

getNewDotfiles() {
	read -r -p "What is the correct path? " path
	DOTFILES=$path
}

# Validate and confirm dotfiles path
while true; do
	# Validate path
	if [ ! -d "$DOTFILES" ]; then
		echo "Could not locate .dotfiles at expected path $DOTFILES"
		getNewDotfiles
	fi

	# Confirm path
	read -r -p "The path of dotfiles is set at $DOTFILES. Is this correct? [Y]es [n]o: " answer
	answer=$(echo "$answer" | awk '{print tolower($0)}')

	if [[ $answer == "n" || $answer == "no" ]]; then
		getNewDotfiles
	else
		HOMEFILES=$DOTFILES/home
		CONFIGFILES=$DOTFILES/.config
		SCRIPTS=$DOTFILES/scripts
		break
	fi
done

if [ ! -d "$SCRIPTS" ] || [ ! -d "$HOMEFILES" ] || [ ! -d "$CONFIGFILES" ]; then
	echo "One or more directories are missing:"
	[ ! -d "$SCRIPTS" ] && echo "  $SCRIPTS"
	[ ! -d "$HOMEFILES" ] && echo "  $HOMEFILES"
	[ ! -d "$CONFIGFILES" ] && echo "  $CONFIGFILES"
	echo "Quitting..."
	exit 1

fi

# FOR CHANGING THE FOLDER STRUCTURE AND REFLECTING ON .bashrc
allowChangeStructure() {
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

	echo "Answer is $answer"

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
}
# allowChangeStructure


# ADDITIONAL SOFTWARE #
bash "$SCRIPTS/utils/setup-packages.sh"
