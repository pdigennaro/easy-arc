#!/bin/sh

GITHUB_DESKTOP_LINK=https://github.com/shiftkey/desktop/releases/download/release-3.2.1-linux1/GitHubDesktop-linux-3.2.1-linux1.AppImage
ANDROID_STUDIO_LINK=https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.18/android-studio-2022.2.1.18-linux.tar.gz
ECLIPSE_LINK=https://mirror.dogado.de/eclipse/technology/epp/downloads/release/2023-03/R/eclipse-jee-2023-03-R-linux-gtk-x86_64.tar.gz
GODOT_LINK=https://github.com/godotengine/godot/releases/download/4.0.2-stable/Godot_v4.0.2-stable_linux.x86_64.zip

echo "
 _______  _______  _______             _______  _______  _______
(  ____ \(  ___  )(  ____ \|\     /|  (  ___  )(  ____ )(  ____ \\\

| (    \/| (   ) || (    \/( \   / )  | (   ) || (    )|| (    \/
| (__    | (___) || (_____  \ (_) /   | (___) || (____)|| |      
|  __)   |  ___  |(_____  )  \   /    |  ___  ||     __)| |      
| (      | (   ) |      ) |   ) (     | (   ) || (\ (   | |      
| (____/\| )   ( |/\____) |   | |     | )   ( || ) \ \__| (____/\\\

(_______/|/     \|\_______)   \_/     |/     \||/   \__/(_______/
"

VER=0.1a
echo "Easy Arc script v. $VER"

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
fi

BLUETOOTH=false
NVIDIA=false

if [ "$#" -gt 2 ]; then
    echo "Illegal number of parameters"
    exit -1
else 	
	for var in "$@"
		do
			#echo "$var"
			
			if [ "$var" == "--bluetooth" ]; then
				echo "Bluetooth enabled!" 
				BLUETOOTH=true
			fi
			
			if [ "$var" == "--nvidia" ]; then
				echo "Nvidia enabled!"
				NVIDIA=true
			fi
		done

fi

echo Insert your name, please
read current_name

echo Insert your email, please
read email

sudo pacman -S --needed ntp zim libreoffice-fresh r rhythmbox filezilla uget qbittorrent vlc geany p7zip gimp cheese exfat-utils fuse-exfat gparted conky plank qtox xclip \
							python-pip tk tilix meld redshift vulkan-tools cmake ninja clang blender mariadb nginx xorg xfce4 xfce4-goodies file-roller leafpad galculator lightdm lightdm-gtk-greeter \
							lightdm-gtk-greeter-settings capitaine-cursors arc-gtk-theme xdg-user-dirs-gtk devtools git jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-doc \
							jre17-openjdk-headless jre17-openjdk jdk17-openjdk openjdk17-doc texstudio texmaker texlive-most ntp ufw wget alacarte cups cups-pdf simple-scan alsa-utils pulseaudio pavucontrol \
							pulseaudio-alsa usbutils simple-scan cups cups-pdf docker xfce4-whiskermenu-plugin thunderbird papirus-icon-theme gvfs nfts-3g firefox chromium jq \
							virtualbox audacity

sudo usermod -aG docker ${USER}

sudo systemctl start pulseaudio

sudo systemctl start cups.service
sudo systemctl enable cups.service

sudo timedatectl set-timezone Europe/Rome
sudo timedatectl set-ntp true
sudo systemctl start ntpd && sudo systemctl enable ntpd
sudo ntpq -p

sudo pacman -S ufw
sudo ufw enable

sudo systemctl enable cups.service

pip install rangehttpserver

if "$NVIDIA"; then
	sudo pacman -S nvidia lib32-nvidia-utils nvidia-settings
fi 

if "$BLUETOOTH"; then
	echo "Enable bluetooth audio!"
	sudo pacman -S bluez bluez-utils blueman pulseaudio-bluetooth
	sudo systemctl enable bluetooth.service
	sudo systemctl start bluetooth.service
fi

git config --global core.editor "vim"
git config --global user.email "$current_name"
git config --global user.name "$email"

sudo archlinux-java set java-17-openjdk

# dotnet
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo chmod +x ./dotnet-install.sh 
./dotnet-install.sh --version latest
./dotnet-install.sh --channel 7.0

# SSH keygen generation
ssh-keygen -t ed25519 -C "$email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

# snap support
git clone https://aur.archlinux.org/snapd.git
cd snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# install snap packages
sudo snap install rider --classic
sudo snap install pycharm-community --classic
sudo snap install clion --classic
sudo snap install intellij-idea-community --classic
sudo snap install code --classic
sudo snap install codium --classic
sudo snap install telegram-desktop
sudo snap install flutter --classic
flutter sdk-path

# some custom software
cd ~
mkdir bins
cd bins

BINS_FOLDER=$(pwd)

wget $GITHUB_DESKTOP_LINK -o Github_desktop_latest.appimage
cd ~ 
sudo mkdir /opt/android
sudo chown -R $USER /opt/android
mkdir /opt/android/sdks
wget $ANDROID_STUDIO_LINK
tar zxvf android-studio-*.tar.gz
mv ./android-studio /opt/android/studio

wget $ECLIPSE_LINK
tar zxvf eclipse*.tar.gz
sudo mv ./eclipse/ /opt/eclipse

wget $GODOT_LINK
unzip Godot_*.zip
mv ./Godot_*.x86_64 $BINS_FOLDER/Godot_latest.x86_64
