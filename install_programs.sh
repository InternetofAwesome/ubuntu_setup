#!/bin/bash 
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install gimp inkscape compizconfig-settings-manager python-setuptools python-dev build-essential minicom git gconf-editor dconf-editor

#install pip
sudo easy_install pip

dconf load /org/compiz/profiles/unity/plugins/grid/ < ./grid-settings.conf
gconftool-2 --load ./lock_screen_key.xml

