#!/bin/bash

# Check that install is in the path
inPath(){
	source $HOME/.bashrc
	directory="$1"
	if [[ ! $PATH =~ "$directory" ]]
	then
		echo "addToPath $directory" >> $HOME/.bashrc
		echo "$directory was added to path"
	fi
}

# EFM Language Server
go install github.com/mattn/efm-langserver@latest
inPath "$HOME/go/bin"

source $HOME/.bashrc
