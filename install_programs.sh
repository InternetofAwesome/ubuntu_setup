#!/bin/bash 

if [ "$(whoami)" != "root" ]; then
	echo "you must run this as root"
	exit
fi

PKGS="gimp \
	inkscape \
	compizconfig-settings-manager \
	python-setuptools \
	python-dev \
	build-essential \
	minicom \
	git \
	gconf-editor \
	dconf-editor \
	curl \
	gparted"

#add chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
PKGS+=" google-chrome-stable"

#add sublime ppa
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y
PKGS+=" sublime-text-installer"

#add java ppa
sudo add-apt-repository ppa:webupd8team/java -y
#say yes to EULAs.
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
PKGS+=" oracle-java8-installer"

#arm compiler ppas
sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa -y
PKGS+=" gcc-arm-embedded"

#airplay casting ability
ver=$(curl http://jcenter.bintray.com/org/jmdns/jmdns/maven-metadata.xml | sed  -n 's/.\+latest[^0-9]\+\([0-9\.-]\+\)..latest./\1/p')
wget http://jcenter.bintray.com/org/jmdns/jmdns/$ver/jmdns-$ver.jar -O ~/jmdns.jar
ver=$(curl http://repo2.maven.org/maven2/org/slf4j/slf4j-nop/maven-metadata.xml | sed  -n 's/.\+latest[^0-9-]\+\([0-9a-zA-Z\.-]\+\)..latest./\1/p')
wget http://repo2.maven.org/maven2/org/slf4j/slf4j-nop/$ver/slf4j-nop-$ver.jar -O ~/slf4j-nop.jar
wget http://repo2.maven.org/maven2/org/slf4j/slf4j-api/1.8.0-alpha2/slf4j-api-1.8.0-alpha2.jar -O ~/slf4j-api.jar
wget https://github.com/$(wget https://github.com/jamesdlow/open-airplay/releases/latest -O - | egrep '/.*/.*/.*jar' -o)
mv ./airplay.jar ~/airplay.jar
desktop-file-install ./open-airplay.desktop

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get install -y $PKGS

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
mv ./eclipse /opt/
desktop-file-install ./eclipse.desktop
