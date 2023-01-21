#!/bin/bash

# shell color code
g='\e[32m'    # Coloured echo (green)
c='\e[36m'    # Coloured echo (cyan)
y='\e[93m'    # Coloured echo (yellow)
r='tput sgr0' #Reset colour after echo

# disable keyboard module (comment to keep it default)
gsettings set com.deepin.dde.dock.module.keyboard enable false

# ================= helper functions =================
# include functions for different packages
DOWNLOADS=${HOME}/Downloads

checkInstalled() {
	echo -e "${y}Checking if $1 is installed."
	${r}
	source ~/.profile
	source ~/.bashrc
	if [[ -z $(which "$1") ]]; then
		echo -e "${y}$1 is not installed, installing it first."
		${r}
		eval "$2"
	else
		echo -e "${y}$1 is already installed, Skipping."
		${r}
	fi
}

# install vivaldi
installVivaldi() {
	# 	wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/u
	# 	r/share/keyrings/vivaldi-browser.gpg
	# 	echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)]
	# https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
	# 	sudo apt update && sudo apt install vivaldi-stable -y
	sudo apt install com.vivaldi.vivaldi -y
}

# install motrix
installMotrix() {
	# aria2c --console-log-level=error --summary-interval=0 "$(wget -qO- https://api.github.com/repos/agalwood/Motrix/releases |
	# 	grep browser_download_url | grep amd64.deb | head -n1 | cut -d '"' -f4)" \
	# 	-d "${DOWNLOADS}" -o "motrix.deb"
	# sudo gdebi "${DOWNLOADS}"/motrix.deb
	# rm "${DOWNLOADS}"/motrix.deb
	sudo apt install com.github.motrix -y
}

# install spark-store
installSparkStore() {
	wget -c 'https://gitee.com/deepin-community-store/spark-store/attach_files/1121708/download/spark-store_3.1.3-1_amd64.deb' \
		-O "${DOWNLOADS}"/spark-store.deb
	sudo gdebi "${DOWNLOADS}"/spark-store.deb
	rm "${DOWNLOADS}"/spark-store.deb
}

# install yesplaymusic
installYesPlayMusic() {
	aria2c --console-log-level=error --summary-interval=0 "$(wget -qO- https://api.github.com/repos/qier222/YesPlayMusic/releases |
		grep browser_download_url | grep amd64.deb | head -n1 | cut -d '"' -f4)" \
		-d "${DOWNLOADS}" -o "yesplaymusic.deb"
	sudo gdebi "${DOWNLOADS}"/yesplaymusic.deb
	rm "${DOWNLOADS}"/yesplaymusic.deb
}

# install zotero-deb
installZotero() {
	# wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
	# sudo apt update -y
	# sudo apt install zotero -y
	sudo apt install org.zotero.zotero-standalone -y
}

installCode() {
	aria2c --console-log-level=error --summary-interval=0 "https://go.microsoft.com/fwlink/?LinkID=760868" \
		-d "${DOWNLOADS}" -o "vscode.deb"
	sudo gdebi "${DOWNLOADS}"/vscode.deb
	rm "${DOWNLOADS}"/vscode.deb
}

installWPS() {
	sudo apt install cn.wps.wps-office -y
	installWPSFonts
}

installWPSFonts() {
	# set up the fonts
	# tar -xvf wps-office.tar.xz
	gzip -kd wps-office/*
	sudo mkdir -p /usr/share/fonts/wps-office/
	sudo cp -r wps-office/*.ttf /usr/share/fonts/wps-office/
	rm -f wps-office/*.ttf wps-office/*.ttc wps-office/*.TTF
}

# install shadowsocks-electron
installShadowsocks() {
	aria2c --console-log-level=error --summary-interval=0 "$(wget -qO- https://api.github.com/repos/nojsja/shadowsocks-electron/releases |
		grep browser_download_url | grep amd64.deb | head -n1 | cut -d '"' -f4)" \
		-d "${DOWNLOADS}" -o "shadowsocks.deb"
	sudo gdebi "${DOWNLOADS}"/shadowsocks.deb
	rm "${DOWNLOADS}"/shadowsocks.deb
}

installRclone() {
	# install rclone & setup onedrive and megasync
	sudo -v
	curl https://rclone.org/install.sh | sudo bash
	# you should replace paths in rclone* and mkdir to fit your need.
	#sudo cp ./rclone* "${HOME}/.config/systemd/user/"
	#mkdir -p "${HOME}/OneDrive-Personal"
	#mkdir -p "${HOME}/OneDrive-UChicago"
	#mkdir -p "${HOME}/MegaSync"
}

installEudic() {
	aria2c --console-log-level=error --summary-interval=0 "https://www.eudic.net/download/eudic.deb" \
		-d "${DOWNLOADS}" -o "eudic.deb"
	sudo gdebi "${DOWNLOADS}"/eudic.deb
	rm "${DOWNLOADS}"/eudic.deb
}

installZoom() {
	aria2c --console-log-level=error --summary-interval=0 "https://zoom.cn/client/latest/zoom_amd64.deb" \
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
	aria2c --console-log-level=error --summary-interval=0 "$(wget -qO- https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases |
		grep browser_download_url | grep amd64.deb | head -n1 | cut -d '"' -f4)" \
		-d "${DOWNLOADS}" -o "heroic.deb"
	sudo gdebi "${DOWNLOADS}"/heroic.deb
	rm "${DOWNLOADS}"/heroic.deb
}

# install Foxit PDF reader
installFoxitPDF() {
	wget "https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Linux-64-bit&version=&package_type=&language=English" -O "${DOWNLOADS}"/foxit.tar.gz
	filename=$(tar ztf "${DOWNLOADS}"/foxit.tar.gz)
	tar -xvzf "${DOWNLOADS}"/foxit.tar.gz # get extracted filename
	rm "${DOWNLOADS}"/foxit.tar.gz
	sudo ./${filename}
	rm $filename
}

installDuplicati() {
	curl -s https://api.github.com/repos/duplicati/duplicati/releases | grep -o -e "https:.*.deb" | awk 'NR==2' | xargs wget -O duplicati.deb
	mkdir deb-temp
	cd deb-temp
	ar x ../duplicati.deb
	zstd -d *.zst
	rm *.zst
	xz *.tar
	ar r ../duplicati_XZ.deb debian-binary control.tar.xz data.tar.xz
	cd ..
	sudo gdebi duplicati_XZ.deb
	rm duplicati.deb duplicati_XZ.deb
	rm deb-temp/ -r
}

installFastGithub() {
	echo "" >>~/.bashrc
	echo "" >>~/.bashrc
	echo "fastgithub() {
		# Check if the parameter is 'start' or 'stop'
		if [ '$1' == 'start' ]; then
			# Start the service
			sudo ~/.fastgithub/fastgithub start
			export http_proxy=http://127.0.0.1:38457
			export https_proxy=http://127.0.0.1:38457
		elif [ '$1' == 'stop' ]; then
			# Stop the service
			sudo ~/.fastgithub/fastgithub stop
			unset http_proxy
			unset https_proxy
		else
			# If the parameter is not 'start' or 'stop', print an error message
			echo 'Error: Invalid parameter. Must be either start or stop.'
		fi
	}" >>~/.bashrc
	unzip -d ~ ./packages/fastgithub_linux-x64.zip
	mv ~/fastgithub_linux-x64 ~/.fastgithub
}

# ================= execute sequence =================

# 3 seconds wait time to start the setup
for i in $(seq 3 -1 1); do
	echo -ne "$i\rThe setup will start in... "
	sleep 1
done
echo ""

# install whiptail
echo -e "${g}Installing whiptail."
${r}
checkInstalled whiptail "sudo apt install whiptail -y"

# install gdebi
echo -e "${g}Installing gdebi."
${r}
checkInstalled gdebi "sudo apt install gdebi -y"

# install aria2c
echo -e "${g}Installing aria2."
${r}
checkInstalled aria2c "sudo apt-get install aria2 -y"

# install git
echo -e "${g}Installing git."
${r}
checkInstalled git "sudo apt-get install git -y"

# install emoji
echo -e "${g}Installing color emoji."
${r}
checkInstalled fonts-noto-color-emoji "sudo apt-get install fonts-noto-color-emoji -y"

# Upgrade and Update Command
echo -e "${g}Updating and upgrading before performing further operations."
${r}
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
# sudo apt autoremove -y

#Setting up Git
read -p "${g}Do you want to setup Git global config? (y/n): " -r
${r}
echo
if [[ ${r}EPLY =~ ^[Yy]$ ]]; then
	echo -e "${g}Setting up global git config at ~/.gitconfig"
	${r}
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${g}Git Setup Successfully!"
	${r}
else
	echo -e "${g}Skipping!"
	${r} && :
fi

dialogbox=(whiptail --separate-output --ok-button "Install" --title "Auto Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)

options=(1 "Spark-Store" off
	2 "Vivaldi" off
	3 "Thunderbird" off
	4 "Motrix" off
	5 "YesPlayMusic" off
	6 "Zotero" off
	7 "Calibre" off
	8 "Joplin" off
	9 "VSCode" off
	10 "WPS-CN" off
	11 "Shadowsocks-Electron" off
	12 "rclone" off
	13 "Eudic" off
	14 "Zoom" off
	15 "PulseAudio" off
	16 "Vulkan" off
	17 "Steam" off
	18 "Heroic Game Launcher" off
	19 "Foxit PDF Reader" off
	20 "Duplicati" off
	21 "FastGithub" off
	22 "WPS-Fonts" off
)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)
for choices in $selected; do
	case $choices in
	1)
		echo -e "${g}Installing Spark-Store"
		${r}
		checkInstalled spark-store installSparkStore
		;;

	2)
		echo -e "${g}Installing Vivaldi"
		${r}
		# install vivaldi browser
		checkInstalled com.vivaldi.vivaldi installVivaldi
		;;

	3)
		echo -e "${g}Installing Thunderbird"
		${r}
		checkInstalled net.thunderbird "sudo apt-get install net.thunderbird -y"
		;;

	4)
		echo -e "${g}Installing Motrix"
		${r}
		checkInstalled com.github.motrix installMotrix
		;;

	5)
		echo -e "${g}Installing YesPlayMusic"
		${r}
		checkInstalled yesplaymusic installYesPlayMusic
		;;

	6)
		echo -e "${g}Installing Zotero"
		${r}
		checkInstalled org.zotero.zotero-standalone installZotero
		;;

	7)
		echo -e "${g}Installing Calibre"
		${r}
		# install calibre=5.44
		checkInstalled com.calibre-ebook.calibre "sudo apt-get install com.calibre-ebook.calibre -y"
		;;

	8)
		echo -e "${g}Installing Joplin"
		${r}
		# install joplin
		wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
		;;

	9)
		echo -e "${g}Installing Visual Studio Code"
		${r}
		checkInstalled code installCode
		;;

	10)
		echo -e "${g}Installing WPS-CN"
		${r}
		# checkInstalled cn.wps.wps-office "sudo apt install cn.wps.wps-office -y"
		checkInstalled cn.wps.wps-office installWPS
		;;

	11)
		echo -e "${g}Installing Shadowsocks-Electron"
		${r}
		checkInstalled shadowsocks-electron installShadowsocks
		;;

	12)
		echo -e "${g}Installing rclone"
		${r}
		checkInstalled rclone installRclone
		;;

	13)
		echo -e "${g}Installing Eudic"
		${r}
		checkInstalled eudic installEudic
		;;

	14)
		echo -e "${g}Installing zoom"
		${r}
		checkInstalled zoom installZoom
		;;

	15)
		echo -e "${g}Installing PulseAudio"
		${r}
		checkInstalled pulseaudio "sudo apt-get install pulseaudio -y"
		;;

	16)
		echo -e "${g}Installing Vulkan"
		${r}
		installVulkan
		;;

	17)
		echo -e "${g}Installing Steam"
		${r}
		checkInstalled steam installSteam
		;;

	18)
		echo -e "${g}Installing Heroic Game Launcher"
		${r}
		checkInstalled heroic installHeroic
		;;

	19)
		echo -e "${g}Installing Foxit PDF Reader"
		${r}
		installFoxitPDF
		;;

	20)
		echo -e "${g}Installing Duplicati backup service"
		${r}
		installDuplicati
		;;

	21)
		echo -e "${g}Installing FastGithub proxy service"
		${r}
		installFastGithub
		;;

	22)
		echo -e "${g}Installing WPS fonts"
		${r}
		installWPSFonts
		;;
	esac
done

# Final Upgrade and Update Command
echo -e "${g}Updating and upgrading to finish auto-setup script."
${r}
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
sudo apt autoremove -y
