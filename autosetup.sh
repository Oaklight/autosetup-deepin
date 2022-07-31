#!/bin/bash

c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0' #Reset colour after echo

DOWNLOADS=${HOME}/Downloads

checkInstalled() {
	echo -e "${c}Checking if $1 is installed."; $r
	source ~/.profile
	source ~/.bashrc
	if [[ -z $(which $1) ]]; then
			echo -e "${c}$1 is not installed, installing it first."; $r
			$2
	else
			echo -e "${c}$1 is already installed, Skipping."; $r
	fi
}


# 3 seconds wait time to start the setup
for i in `seq 3 -1 1` ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done

# install whiptail
echo -e "{c}Installing whiptail."; $r
checkInstalled whiptail
sudo apt install whiptail -y

# install gdebi
echo -e "${c}Installing gdebi."; $r
checkInstalled gdebi
sudo apt install gdebi -y

# install aria2c
echo -e "{c}Installing aria2."; $r
checkInstalled aria2c
sudo apt-get install aria2 -y

# Upgrade and Update Command
echo -e "${c}Updating and upgrading before performing further operations."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
sudo apt autoremove -y

#Setting up Git
read -p "${y}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${c}Setting up global git config at ~/.gitconfig"; $r
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${c}Git Setup Successfully!"; $r
else
	echo -e "${c}Skipping!"; $r && :
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
	17 "Heroic Game Launcher" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)
for choices in $selected
do
	case $choices in
		1)
		echo -e "${c}Installing Better-DDE"; $r
		# install better-dde
		wget -q -O - https://better-dde.github.io/ppa/better-dde.gpg | sudo apt-key add -
		sudo sh -c 'echo "deb https://better-dde.github.io/ppa/ ./" > /etc/apt/sources.list.d/better-dde.list'
		sudo apt update && sudo apt dist-upgrade -y
		;;

		2)
		echo -e "${c}Installing Vivaldi"; $r
		# install vivaldi browser
		checkInstalled vivaldi-stable
		wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg
		echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
		sudo apt update && sudo apt install vivaldi-stable -y
		;;

		3)
 		echo -e "${c}Installing Thunderbird"; $r
		checkInstalled thunderbird
		# install thunderbird
		sudo apt-get install thunderbird -y
 		;;

 		4)
		echo -e "${c}Installing Motrix"; $r
		# install motrix
		checkInstalled motrix
		aria2c --console-log-level=error --summary-interval=0\
		    "$(wget -qO- https://api.github.com/repos/agalwood/Motrix/releases|\
		    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
                 -d ${DOWNLOADS} -o "motrix.deb"
		sudo gdebi ${DOWNLOADS}/motrix.deb
		rm ${DOWNLOADS}/motrix.deb
		;;

		5)
		echo -e "${c}Installing Spark-Store"; $r
		# install spark-store
		checkInstalled spark-store
		wget -c 'https://gitee.com/deepin-community-store/spark-store/attach_files/1121708/download/spark-store_3.1.3-1_amd64.deb'\
		-O ${DOWNLOADS}/spark-store.deb
		sudo gdebi ${DOWNLOADS}/spark-store.deb
		rm ${DOWNLOADS}/spark-store.deb
		;;

		6)
		echo -e "${c}Installing YesPlayMusic"; $r
		# install yesplaymusic
		checkInstalled yesplaymusic
		aria2c --console-log-level=error --summary-interval=0\
		    "$(wget -qO- https://api.github.com/repos/qier222/YesPlayMusic/releases|\
		    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
		    -d ${DOWNLOADS} -o "yesplaymusic.deb"
		sudo gdebi ${DOWNLOADS}/yesplaymusic.deb
		rm ${DOWNLOADS}/yesplaymusic.deb
		;;

		7)
		echo -e "${c}Installing Zotero"; $r
		# install zotero-deb
		checkInstalled zotero
		wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
		sudo apt update -y
		sudo apt install zotero -y
		;;

		8)
		echo -e "${c}Installing Calibre"; $r
		# install calibre=5.44
		# checkInstalled calibre
		# sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin version=5.44.0
		sudo apt-get install com.calibre-ebook.calibre -y
		;;

		9)
		echo -e "${c}Installing Joplin"; $r
		# install joplin
		wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
		;;

		10)
		echo -e "${c}Installing Visual Studio Code"; $r
		checkInstalled code
		# install vscodium
		aria2c --console-log-level=error --summary-interval=0\
		    "https://go.microsoft.com/fwlink/?LinkID=760868"\
		    -d ${DOWNLOADS} -o "vscode.deb"
		sudo gdebi ${DOWNLOADS}/vscode.deb
		rm ${DOWNLOADS}/vscode.deb
		;;

		11)
		echo -e "${c}Installing WPS-CN"; $r
		checkInstalled cn.wps.wps-office
		# install wps-cn
	 	# aria2c --console-log-level=error --summary-interval=0\
		# 	'https://wps-linux-personal.wpscdn.cn/wps/download/ep/Linux2019/11664/wps-office_11.1.0.11664_amd64.deb'\
		# 	-x 5 \
		# 	-d ${DOWNLOADS} -o "wps-office.deb"
		# sudo gdebi ${DOWNLOADS}/wps-office.deb
		# rm ${DOWNLOADS}/wps-office.deb
		sudo apt install cn.wps.wps-office -y
		;;

		12)
		echo -e "${c}Installing Shadowsocks-Electron"; $r
		checkInstalled shadowsocks-electron
		# install shadowsocks-electron
		aria2c --console-log-level=error --summary-interval=0\
		    "$(wget -qO- https://api.github.com/repos/nojsja/shadowsocks-electron/releases|\
		    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
		    -d ${DOWNLOADS} -o "shadowsocks.deb"
		sudo gdebi ${DOWNLOADS}/shadowsocks.deb
		rm ${DOWNLOADS}/shadowsocks.deb
		;;

		13)
		echo -e "${c}Installing rclone"; $r
		checkInstalled rclone
		# install rclone & setup onedrive and megasync
		sudo -v ; curl https://rclone.org/install.sh | sudo bash
		#sudo cp ./rclone* "${HOME}/.config/systemd/user/"
		#mkdir "${HOME}/OneDrive-Personal"
		#mkdir "${HOME}/OneDrive-UChicago"
		#mkdir "${HOME}/MegaSync"
		;;

		14)
		echo -e "${c}Installing PulseAudio"; $r
		checkInstalled pulseaudio
		# install pulseaudio
		sudo apt-get install pulseaudio -y
		;;

		15)
		echo -e "${c}Installing Vulkan"; $r
		# install vulkan
		sudo apt install mesa-vulkan-drivers libvulkan1 vulkan-tools vulkan-validationlayers nvidia-vulkan-icd
		;;
		
		16)
		echo -e "${c}Installing Steam"; $r
		checkInstalled steam
		# install steam and heroic game launcher
		wget http://media.steampowered.com/client/installer/steam.deb -O ${DOWNLOADS}/steam.deb
		sudo gdebi ${DOWNLOADS}/steam.deb
		rm ${DOWNLOADS}/steam.deb
		;;

		17)
		echo -e "${c}Installing Steam"; $r
		checkInstalled heroic
		# install heroic game launcher
		aria2c --console-log-level=error --summary-interval=0\
		    "$(wget -qO- https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases|\
		    grep browser_download_url|grep amd64.deb|head -n1|cut -d '"' -f4)"\
		    -d ${DOWNLOADS} -o "heroic.deb"
		sudo gdebi ${DOWNLOADS}/heroic.deb
		rm ${DOWNLOADS}/heroic.deb
		;;
	esac
done



# Final Upgrade and Update Command
echo -e "${c}Updating and upgrading to finish auto-setup script."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
