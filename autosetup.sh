#!/bin/bash

# include functions for different packages
chmod 700 ./autosetup-functions.sh
. autosetup-functions.sh


c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0' #Reset colour after echo


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

# install git
echo -e "${y}Installing git."; $r
checkInstalled git "sudo apt-get install git -y"

# install emoji
echo -e "${y}Installing color emoji."; $r
checkInstalled fonts-noto-color-emoji "sudo apt-get install fonts-noto-color-emoji -y"

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
		echo -e "${y}Installing Better-DDE"; $r
		# install better-dde
		wget -q -O - https://better-dde.github.io/ppa/better-dde.gpg | sudo apt-key add -
		sudo sh -c 'echo "deb https://better-dde.github.io/ppa/ ./" > /etc/apt/sources.list.d/better-dde.list'
		sudo apt update && sudo apt dist-upgrade -y
		;;

		2)
		echo -e "${y}Installing Vivaldi"; $r
		# install vivaldi browser
		checkInstalled vivaldi-stable installVivaldi
		;;

		3)
 		echo -e "${y}Installing Thunderbird"; $r
		checkInstalled net.thunderbird "sudo apt-get install net.thunderbird -y"
 		;;

 		4)
		echo -e "${y}Installing Motrix"; $r
		checkInstalled motrix installMotrix
		;;

		5)
		echo -e "${y}Installing Spark-Store"; $r
		checkInstalled spark-store installSparkStore
		;;

		6)
		echo -e "${y}Installing YesPlayMusic"; $r
		checkInstalled yesplaymusic installYesPlayMusic
		;;

		7)
		echo -e "${y}Installing Zotero"; $r
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
		checkInstalled code installCode
		;;

		11)
		echo -e "${y}Installing WPS-CN"; $r
		checkInstalled cn.wps.wps-office "sudo apt install cn.wps.wps-office -y"
		;;

		12)
		echo -e "${y}Installing Shadowsocks-Electron"; $r
		checkInstalled shadowsocks-electron installShadowsocks
		;;

		13)
		echo -e "${y}Installing rclone"; $r
		checkInstalled rclone installRclone
		;;

		14)
		echo -e "${y}Installing Eudic"; $r
		checkInstalled eudic installEudic
		;;

		15)
		echo -e "${y}Installing zoom"; $r
		checkInstalled zoom installZoom
		;;

		16)
		echo -e "${y}Installing PulseAudio"; $r
		checkInstalled pulseaudio "sudo apt-get install pulseaudio -y"
		;;

		17)
		echo -e "${y}Installing Vulkan"; $r
		installVulkan
		;;
		
		18)
		echo -e "${y}Installing Steam"; $r
		checkInstalled steam installSteam
		;;

		19)
		echo -e "${y}Installing Heroic Game Launcher"; $r
		checkInstalled heroic installHeroic
		;;
	esac
done



# Final Upgrade and Update Command
echo -e "${y}Updating and upgrading to finish auto-setup script."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
sudo apt autoremove -y
