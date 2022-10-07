#!/bin/bash


# shell color code
g='\e[32m' # Coloured echo (green)
c='\e[36m' # Coloured echo (cyan)
y='\e[93m' # Coloured echo (yellow)
r='tput sgr0' #Reset colour after echo

# disable keyboard module (comment to keep it default)
gsettings set com.deepin.dde.dock.module.keyboard enable false

# ================= helper functions =================
# include functions for different packages
DOWNLOADS=${HOME}/Downloads

checkInstalled() {
	echo -e "${y}Checking if $1 is installed."; $r
	source ~/.profile
	source ~/.bashrc
	if [[ -z $(which "$1") ]]; then
			echo -e "${y}$1 is not installed, installing it first."; $r
			eval "$2"
	else
			echo -e "${y}$1 is already installed, Skipping."; $r
	fi
}


# install vivaldi
installVivaldi() {
	wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/u
r/share/keyrings/vivaldi-browser.gpg
	echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)]
https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
	sudo apt update && sudo apt install vivaldi-stable -y
}


# install motrix
installMotrix() {
	aria2c --console-log-level=error --summary-interval=0\
		"$(wget -qO- https://api.github.com/repos/agalwood/Motrix/releases|\
		grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
				-d "${DOWNLOADS}" -o "motrix.deb"
	sudo gdebi "${DOWNLOADS}"/motrix.deb
	rm "${DOWNLOADS}"/motrix.deb
}


# install spark-store
installSparkStore() {		
	wget -c 'https://gitee.com/deepin-community-store/spark-store/attach_files/1121708/download/spark-store_3.1.3-1_amd64.deb'\
	-O "${DOWNLOADS}"/spark-store.deb
	sudo gdebi "${DOWNLOADS}"/spark-store.deb
	rm "${DOWNLOADS}"/spark-store.deb
}


# install yesplaymusic
installYesPlayMusic() {
	aria2c --console-log-level=error --summary-interval=0\
		"$(wget -qO- https://api.github.com/repos/qier222/YesPlayMusic/releases|\
		grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
		-d "${DOWNLOADS}" -o "yesplaymusic.deb"
	sudo gdebi "${DOWNLOADS}"/yesplaymusic.deb
	rm "${DOWNLOADS}"/yesplaymusic.deb
}


# install zotero-deb
installZotero() {
	wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
	sudo apt update -y
	sudo apt install zotero -y
}


installCode() {
	aria2c --console-log-level=error --summary-interval=0\
		"https://go.microsoft.com/fwlink/?LinkID=760868"\
		-d "${DOWNLOADS}" -o "vscode.deb"
	sudo gdebi "${DOWNLOADS}"/vscode.deb
	rm "${DOWNLOADS}"/vscode.deb
}

installWPS() {
	sudo apt install cn.wps.wps-office -y
	# set up the fonts
	tar -xvf wps-office.tar.xz
	sudo cp -r wps-office /usr/share/fonts/
	rm wps-office/ -r
}


# install shadowsocks-electron
installShadowsocks() {
	aria2c --console-log-level=error --summary-interval=0\
		"$(wget -qO- https://api.github.com/repos/nojsja/shadowsocks-electron/releases|\
		grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
		-d "${DOWNLOADS}" -o "shadowsocks.deb"
	sudo gdebi "${DOWNLOADS}"/shadowsocks.deb
	rm "${DOWNLOADS}"/shadowsocks.deb
}


installRclone() {
	# install rclone & setup onedrive and megasync
	sudo -v ; curl https://rclone.org/install.sh | sudo bash
	# you should replace paths in rclone* and mkdir to fit your need.
	#sudo cp ./rclone* "${HOME}/.config/systemd/user/"
	#mkdir -p "${HOME}/OneDrive-Personal"
	#mkdir -p "${HOME}/OneDrive-UChicago"
	#mkdir -p "${HOME}/MegaSync"
}


installEudic() {
	aria2c --console-log-level=error --summary-interval=0\
		"https://www.eudic.net/download/eudic.deb"\
		-d "${DOWNLOADS}" -o "eudic.deb"
	sudo gdebi "${DOWNLOADS}"/eudic.deb
	rm "${DOWNLOADS}"/eudic.deb
}


installZoom() {
	aria2c --console-log-level=error --summary-interval=0\
		"https://zoom.cn/client/latest/zoom_amd64.deb"\
		-d "${DOWNLOADS}" -o "zoom.deb"
	sudo gdebi "${DOWNLOADS}"/zoom.deb
	rm "${DOWNLOADS}"/zoom.deb
}


# install vulkan
installVulkan() {
	sudo apt install libvulkan1:amd64 libvulkan1:i386 vulkan-tools vulkan-utils vulkan-validationlayers -y
	sudo apt install nvidia-vulkan-icd:amd64 nvidia-vulkan-icd:i386 -y
}


installSteam() {
	# install vulkan as pre-requisite
	installVulkan
	# install steam and heroic game launcher
	wget http://media.steampowered.com/client/installer/steam.deb -O "${DOWNLOADS}"/steam.deb
	sudo gdebi "${DOWNLOADS}"/steam.deb
	rm "${DOWNLOADS}"/steam.deb
}


# install heroic game launcher
installHeroic() {
	# install vulkan as pre-requisite
	installVulkan
	aria2c --console-log-level=error --summary-interval=0\
		"$(wget -qO- https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases|\
		grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
		-d "${DOWNLOADS}" -o "heroic.deb"
	sudo gdebi "${DOWNLOADS}"/heroic.deb
	rm "${DOWNLOADS}"/heroic.deb
}


# ================= execute sequence =================

# 3 seconds wait time to start the setup
for i in $(seq 3 -1 1) ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done
echo ""

# install whiptail
echo -e "${g}Installing whiptail."; $r
checkInstalled whiptail "sudo apt install whiptail -y"

# install gdebi
echo -e "${g}Installing gdebi."; $r
checkInstalled gdebi "sudo apt install gdebi -y"

# install aria2c
echo -e "${g}Installing aria2."; $r
checkInstalled aria2c "sudo apt-get install aria2 -y"

# install git
echo -e "${g}Installing git."; $r
checkInstalled git "sudo apt-get install git -y"

# install emoji
echo -e "${g}Installing color emoji."; $r
checkInstalled fonts-noto-color-emoji "sudo apt-get install fonts-noto-color-emoji -y"

# Upgrade and Update Command
echo -e "${g}Updating and upgrading before performing further operations."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
# sudo apt autoremove -y

#Setting up Git
read -p "${g}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${g}Setting up global git config at ~/.gitconfig"; $r
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${g}Git Setup Successfully!"; $r
else
	echo -e "${g}Skipping!"; $r && :
fi

dialogbox=(whiptail --separate-output --ok-button "Install" --title "Auto Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)

options=(1 "Better-DDE" off
	2 "Vivaldi" off
	3 "Thunderbird" off
	4 "Motrix" off
	5 "Spark-Store" off
	6 "YesPlayMusic" off
	7 "Zotero" off
	8 "Calibre" off
	9 "Joplin" off
	10 "VSCode" off
	11 "WPS-CN" off
	12 "Shadowsocks-Electron" off
	13 "rclone" off
	14 "Eudic" off
	15 "Zoom" off
	16 "PulseAudio" off
	17 "Vulkan" off
	18 "Steam" off
	19 "Heroic Game Launcher" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)
for choices in $selected
do
	case $choices in
		1) # be careful to use Better-DDE, it's very likely the one that triggers DDE message center problem.
		echo -e "${g}Installing Better-DDE"; $r
		# install better-dde
		wget -q -O - https://better-dde.github.io/ppa/better-dde.gpg | sudo apt-key add -
		sudo sh -c 'echo "deb https://better-dde.github.io/ppa/ ./" > /etc/apt/sources.list.d/better-dde.list'
		sudo apt update && sudo apt dist-upgrade -y
		;;

		2)
		echo -e "${g}Installing Vivaldi"; $r
		# install vivaldi browser
		checkInstalled vivaldi-stable installVivaldi
		;;

		3)
 		echo -e "${g}Installing Thunderbird"; $r
		checkInstalled net.thunderbird "sudo apt-get install net.thunderbird -y"
 		;;

 		4)
		echo -e "${g}Installing Motrix"; $r
		checkInstalled motrix installMotrix
		;;

		5)
		echo -e "${g}Installing Spark-Store"; $r
		checkInstalled spark-store installSparkStore
		;;

		6)
		echo -e "${g}Installing YesPlayMusic"; $r
		checkInstalled yesplaymusic installYesPlayMusic
		;;

		7)
		echo -e "${g}Installing Zotero"; $r
		checkInstalled zotero installZotero
		;;

		8)
		echo -e "${g}Installing Calibre"; $r
		# install calibre=5.44
		checkInstalled com.calibre-ebook.calibre "sudo apt-get install com.calibre-ebook.calibre -y"
		;;

		9)
		echo -e "${g}Installing Joplin"; $r
		# install joplin
		wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
		;;

		10)
		echo -e "${g}Installing Visual Studio Code"; $r
		checkInstalled code installCode
		;;

		11)
		echo -e "${g}Installing WPS-CN"; $r
		checkInstalled cn.wps.wps-office "sudo apt install cn.wps.wps-office -y"
		checkInstalled cn.wps.wps-office installWPS
		;;

		12)
		echo -e "${g}Installing Shadowsocks-Electron"; $r
		checkInstalled shadowsocks-electron installShadowsocks
		;;

		13)
		echo -e "${g}Installing rclone"; $r
		checkInstalled rclone installRclone
		;;

		14)
		echo -e "${g}Installing Eudic"; $r
		checkInstalled eudic installEudic
		;;

		15)
		echo -e "${g}Installing zoom"; $r
		checkInstalled zoom installZoom
		;;

		16)
		echo -e "${g}Installing PulseAudio"; $r
		checkInstalled pulseaudio "sudo apt-get install pulseaudio -y"
		;;

		17)
		echo -e "${g}Installing Vulkan"; $r
		installVulkan
		;;
		
		18)
		echo -e "${g}Installing Steam"; $r
		checkInstalled steam installSteam
		;;

		19)
		echo -e "${g}Installing Heroic Game Launcher"; $r
		checkInstalled heroic installHeroic
		;;
	esac
done



# Final Upgrade and Update Command
echo -e "${g}Updating and upgrading to finish auto-setup script."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
sudo apt autoremove -y
