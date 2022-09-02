#!/bin/bash

c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0' #Reset colour after echo

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


# 3 seconds wait time to start the setup
for i in $(seq 3 -1 1) ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done
echo ""

# install whiptail
echo -e "${y}Installing whiptail."; $r
checkInstalled whiptail "sudo apt install whiptail -y"

# install gdebi
echo -e "${y}Installing gdebi."; $r
checkInstalled gdebi "sudo apt install gdebi -y"

# install aria2c
echo -e "${y}Installing aria2."; $r
checkInstalled aria2c "sudo apt-get install aria2 -y"

# Upgrade and Update Command
echo -e "${y}Updating and upgrading before performing further operations."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
# sudo apt autoremove -y

#Setting up Git
read -p "${y}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${y}Setting up global git config at ~/.gitconfig"; $r
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${y}Git Setup Successfully!"; $r
else
	echo -e "${y}Skipping!"; $r && :
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
	14 "PulseAudio" off
	15 "Vulkan" off
	16 "Steam" off
	17 "Heroic Game Launcher" off
	18 "Eudic" off
	19 "Zoom" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)
for choices in $selected
do
	case $choices in
		1) # be careful to use Better-DDE, it's very likely the one that triggers DDE message center problem.
		echo -e "${y}Installing Better-DDE"; $r
		# install better-dde
		wget -q -O - https://better-dde.github.io/ppa/better-dde.gpg | sudo apt-key add -
		sudo sh -c 'echo "deb https://better-dde.github.io/ppa/ ./" > /etc/apt/sources.list.d/better-dde.list'
		sudo apt update && sudo apt dist-upgrade -y
		;;

		2)
		echo -e "${y}Installing Vivaldi"; $r
		# install vivaldi browser
		installVivaldi() {
			wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg
			echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
			sudo apt update && sudo apt install vivaldi-stable -y
		}
		checkInstalled vivaldi-stable installVivaldi
		;;

		3)
 		echo -e "${y}Installing Thunderbird"; $r
		checkInstalled thunderbird "sudo apt-get install thunderbird -y"
 		;;

 		4)
		echo -e "${y}Installing Motrix"; $r
		# install motrix
		installMotrix() {
			aria2c --console-log-level=error --summary-interval=0\
			    "$(wget -qO- https://api.github.com/repos/agalwood/Motrix/releases|\
			    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
	                 -d "${DOWNLOADS}" -o "motrix.deb"
			sudo gdebi "${DOWNLOADS}"/motrix.deb
			rm "${DOWNLOADS}"/motrix.deb
		}
		checkInstalled motrix installMotrix
		;;

		5)
		echo -e "${y}Installing Spark-Store"; $r
		# install spark-store
		installSparkStore() {		
			wget -c 'https://gitee.com/deepin-community-store/spark-store/attach_files/1121708/download/spark-store_3.1.3-1_amd64.deb'\
			-O "${DOWNLOADS}"/spark-store.deb
			sudo gdebi "${DOWNLOADS}"/spark-store.deb
			rm "${DOWNLOADS}"/spark-store.deb
		}
		checkInstalled spark-store installSparkStore
		;;

		6)
		echo -e "${y}Installing YesPlayMusic"; $r
		# install yesplaymusic
		installYesPlayMusic() {
			aria2c --console-log-level=error --summary-interval=0\
			    "$(wget -qO- https://api.github.com/repos/qier222/YesPlayMusic/releases|\
			    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
			    -d "${DOWNLOADS}" -o "yesplaymusic.deb"
			sudo gdebi "${DOWNLOADS}"/yesplaymusic.deb
			rm "${DOWNLOADS}"/yesplaymusic.deb
		}
		checkInstalled yesplaymusic installYesPlayMusic
		;;

		7)
		echo -e "${y}Installing Zotero"; $r
		# install zotero-deb
		installZotero() {
			wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
			sudo apt update -y
			sudo apt install zotero -y
		}
		checkInstalled zotero installZotero
		;;

		8)
		echo -e "${y}Installing Calibre"; $r
		# install calibre=5.44
		checkInstalled com.calibre-ebook.calibre "sudo apt-get install com.calibre-ebook.calibre -y"
		;;

		9)
		echo -e "${y}Installing Joplin"; $r
		# install joplin
		wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
		;;

		10)
		echo -e "${y}Installing Visual Studio Code"; $r
		installCode() {
			aria2c --console-log-level=error --summary-interval=0\
			    "https://go.microsoft.com/fwlink/?LinkID=760868"\
			    -d "${DOWNLOADS}" -o "vscode.deb"
			sudo gdebi "${DOWNLOADS}"/vscode.deb
			rm "${DOWNLOADS}"/vscode.deb
		}
		checkInstalled code installCode
		;;

		11)
		echo -e "${y}Installing WPS-CN"; $r
		checkInstalled cn.wps.wps-office "sudo apt install cn.wps.wps-office -y"
		;;

		12)
		echo -e "${y}Installing Shadowsocks-Electron"; $r
		# install shadowsocks-electron
		installShadowsocks() {
			aria2c --console-log-level=error --summary-interval=0\
			    "$(wget -qO- https://api.github.com/repos/nojsja/shadowsocks-electron/releases|\
			    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
			    -d "${DOWNLOADS}" -o "shadowsocks.deb"
			sudo gdebi "${DOWNLOADS}"/shadowsocks.deb
			rm "${DOWNLOADS}"/shadowsocks.deb
		}
		checkInstalled shadowsocks-electron installShadowsocks
		;;

		13)
		echo -e "${y}Installing rclone"; $r
		installRclone() {
			# install rclone & setup onedrive and megasync
			sudo -v ; curl https://rclone.org/install.sh | sudo bash
			#sudo cp ./rclone* "${HOME}/.config/systemd/user/"
			#mkdir -p "${HOME}/OneDrive-Personal"
			#mkdir -p "${HOME}/OneDrive-UChicago"
			#mkdir -p "${HOME}/MegaSync"
		}
		checkInstalled rclone installRclone
		;;

		14)
		echo -e "${y}Installing PulseAudio"; $r
		checkInstalled pulseaudio "sudo apt-get install pulseaudio -y"
		;;

		15)
		echo -e "${y}Installing Vulkan"; $r
		# install vulkan
		sudo apt install mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-validationlayers nvidia-vulkan-icd -y
		;;
		
		16)
		echo -e "${y}Installing Steam"; $r
		installSteam() {
			# install steam and heroic game launcher
			wget http://media.steampowered.com/client/installer/steam.deb -O "${DOWNLOADS}"/steam.deb
			sudo gdebi "${DOWNLOADS}"/steam.deb
			rm "${DOWNLOADS}"/steam.deb
		}
		checkInstalled steam installSteam
		;;

		17)
		echo -e "${y}Installing Heroic Game Launcher"; $r
		# install heroic game launcher
		installHeroic() {
			aria2c --console-log-level=error --summary-interval=0\
			    "$(wget -qO- https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases|\
			    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
			    -d "${DOWNLOADS}" -o "heroic.deb"
			sudo gdebi "${DOWNLOADS}"/heroic.deb
			rm "${DOWNLOADS}"/heroic.deb
		}
		checkInstalled heroic installHeroic
		;;

		18)
		echo -e "${y}Installing Eudic"; $r
		installEudic() {
			aria2c --console-log-level=error --summary-interval=0\
			    "https://www.eudic.net/download/eudic.deb"\
			    -d "${DOWNLOADS}" -o "eudic.deb"
			sudo gdebi "${DOWNLOADS}"/eudic.deb
			rm "${DOWNLOADS}"/eudic.deb
		}
		checkInstalled eudic installEudic
		;;

		19)
		echo -e "${y}Installing zoom"; $r
		installZoom() {
			aria2c --console-log-level=error --summary-interval=0\
			    "https://zoom.cn/client/latest/zoom_amd64.deb"\
			    -d "${DOWNLOADS}" -o "zoom.deb"
			sudo gdebi "${DOWNLOADS}"/zoom.deb
			rm "${DOWNLOADS}"/zoom.deb
		}
		checkInstalled zoom installZoom
		;;
	esac
done



# Final Upgrade and Update Command
echo -e "${y}Updating and upgrading to finish auto-setup script."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
sudo apt autoremove -y
