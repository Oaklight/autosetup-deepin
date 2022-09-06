#!/bin/bash

DOWNLOADS=${HOME}/Downloads


checkInstalled() {
	echo -e "${c}Checking if $1 is installed."; $r
	source ~/.profile
	source ~/.bashrc
	if [[ -z $(which "$1") ]]; then
			echo -e "${c}$1 is not installed, installing it first."; $r
			eval "$2"
	else
			echo -e "${c}$1 is already installed, Skipping."; $r
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
	sudo apt install libvulkan1 vulkan-tools vulkan-utils vulkan-validationlayers -y
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