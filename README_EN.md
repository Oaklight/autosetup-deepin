# autosetup

[中文版](./README.md)

- [autosetup](#autosetup)
  - [customize icon themes](#customize-icon-themes)
  - [following packages are installed by default](#following-packages-are-installed-by-default)
  - [setup rclone mount as disk](#setup-rclone-mount-as-disk)
    - [set up bisync for some directory](#set-up-bisync-for-some-directory)
    - [recommended](#recommended)
      - [basic config](#basic-config)
- [Outdated](#outdated)

A simple autosetup script to ease my reinstallation & new system setup :)

Current list of packages:
1. "Vivaldi"
2. "Thunderbird"
3. "Motrix"
4. "Spark-Store"
5. "YesPlayMusic"
6. "Zotero"
7. "Calibre"
8. "Joplin"
9.  "VSCode"
10. "WPS-CN"
11. "Shadowsocks-Electron"
12. "rclone"
13. "PulseAudio"
14. "Eudic"
15. "Zoom"
16. "Vulkan"
17. "Steam"
18. "Heroic Game Launcher"

## customize icon themes

`tar -xf ./themes/icons/<icon-theme>.tar.xz -C ~/.local/share/icons`

## following packages are installed by default

- whiptail
- gdebi
- aria2
- git
- fonts-noto-color-emoji

## setup rclone mount as disk

### set up bisync for some directory

Sometimes, we may want to access certain files offline as well, such as photos, zotero collections, logseq files, etc. `mount` no longer fulfills this demand and `bisync` seems a nice alternative in such scenarios. However, this function only supports [certain cloud systems](https://rclone.org/bisync/#supported-backends). Also, rclone at this moment doesn't support file change monitoring. We will need to use `cron` to make this happen.

```bash
cd ./scripts
chmod +x ./setBisync.sh
./setBisync.sh '/local/target/path/' 'rclone:/remote/path/' [1~60] # mins, default 30 mins
```

### recommended

This wikidoc describes a template way to create rclone services: https://github.com/rclone/rclone/wiki/Systemd-rclone-mount

`rclone@.service` file is the systemd template service file.
> Save the above file to `/etc/systemd/user/rclone@.service` if you want it accessible to the entire system, or `~/.config/systemd/user/rclone@.service`

This script places the file at `~/.config/systemd/user/rclone@.service`

run `systemctl --user daemon-reload` to refresh systemd service list

#### basic config

```bash
# suppose we have "OneDrive-Personal" already configured in rclone
# create local mapping dirs
mkdir -p ~/OneDrive-Personal
systemctl --user start rclone@OneDrive-Personal

# if you could navigate to ~/OneDrive-Personal and see your files
#   you could decide to make the rclone service autostart
systemctl --user enable rclone@OneDrive-Personal
```

***

## Outdated

- Remove better-dde. The way it installs making reverting/uninstallation very difficult, so I decide to drop it from the script. \
  If you wish to use it, do it by yourself or use historical commit of this script.

- This script below is no longer supported. If you wish to use it, please check historical commit
```bash
# create local mapping dirs
mkdir -p ~/OneDrive-Personal
mkdir -p ~/OneDrive-UChicago
mkdir -p ~/MegaSync
# setup systemd service, reference: https://www.guyrutenberg.com/2021/06/25/autostart-rclone-mount-using-systemd/
cp rclone-* ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now rclone-onedrive-personal.service
systemctl --user enable --now rclone-onedrive-uchicago.service
systemctl --user enable --now rclone-megasync.service
```
