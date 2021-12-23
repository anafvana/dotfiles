#!/bin/bash

SCRIPTS=$(echo `pwd`)

# PACKAGES
## Basic setup packages
sudo apt install bspwm sxhkd dunst brightnessctl alsa-utils acpi scrot alacritty

## Additional setup packages
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update

sudo apt install git curl nvim tree silversearcher-ag insync

chmod +x $SCRIPTS/setup.sh
bash $SCRIPTS/setup.sh
