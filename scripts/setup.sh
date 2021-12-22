#!/bin/bash

# basic setup packages
sudo apt install bspwm sxhkd dunst brightnessctl alsa-utils acpi scrot alacritty

# allow brightness changes without sudo
sudo chown root:root /usr/bin/brightnesctl
sudo chmod 4775 /usr/bin/brightnessctl

# additional setup packages
sudo apt install insync tree silversearcher-ag
