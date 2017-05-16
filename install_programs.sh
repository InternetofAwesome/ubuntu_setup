#!/bin/bash 

if [ "$(whoami)" != "root" ]; then
	echo "you must run this as root"
	exit
fi

#add chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

#add sublime ppa
sudo add-apt-repository ppa:webupd8team/sublime-text-3

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get install -y gimp inkscape compizconfig-settings-manager python-setuptools python-dev build-essential minicom git gconf-editor dconf-editor google-chrome-stable submlime-text-installer

#install pip
easy_install pip

dconf load /org/compiz/profiles/unity/plugins/grid/ < ./grid-settings.conf
dconf load /org/compiz/profiles/unity/plugins/grid/ < ./dconf-datetime.conf
gconftool-2 --load ./lock_screen_key.xml

#install chrome

#Move my application shortcuts to where they should go
cp ./org.gnome.Screenshot.desktop ~/.local/share/applications/screenshot.desktop

