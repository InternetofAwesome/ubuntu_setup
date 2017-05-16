#!/bin/bash 

if [ "$(whoami)" != "root" ]; then
	echo "you must run this as root"
	exit
fi

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get install -y gimp inkscape compizconfig-settings-manager python-setuptools python-dev build-essential minicom git gconf-editor dconf-editor

#install pip
easy_install pip

dconf load /org/compiz/profiles/unity/plugins/grid/ < ./grid-settings.conf
gconftool-2 --load ./lock_screen_key.xml

