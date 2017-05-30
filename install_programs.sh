#!/bin/bash 

if [ "$(whoami)" != "root" ]; then
	echo "you must run this as root"
	exit
fi

#add chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

#add sublime ppa
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y

#add java ppa
sudo add-apt-repository ppa:webupd8team/java -y
#say yes to EULAs.
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get install -y gimp inkscape compizconfig-settings-manager python-setuptools python-dev build-essential minicom git gconf-editor dconf-editor google-chrome-stable submlime-text-installer curl gparted oracle-java8-installer

#install pip
easy_install pip

dconf load /org/compiz/profiles/unity/plugins/grid/ < ./grid-settings.conf
dconf load /org/compiz/profiles/unity/plugins/grid/ < ./dconf-datetime.conf
gconftool-2 --load ./lock_screen_key.xml

#install draftsight
wget www.draftsight.com/download-linux-ubuntu -O draftSight.deb
dpkg -i ./draftsight.deb

#Move my application shortcuts to where they should go
cp ./org.gnome.Screenshot.desktop ~/.local/share/applications/screenshot.desktop

#install eclipse
base="http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release"
ver=$(curl $base/release.xml | sed -n 's/.present.\(.*\)..present./\1/p')
ver_url="$base/$ver/eclipse-cpp-${ver//'/'/'-'}-linux-gtk-x86_64.tar.gz"
wget $ver_url -O eclipse.tar.gz
tar xfv ./eclipse.tar.gz
mv ./eclipse /opt/eclipse
desktop-file-install ./eclipse.desktop
