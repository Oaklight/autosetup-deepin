# autosetup

[中文版](./README.md)

A simple autosetup script to ease my reinstallation & new system setup :)

Current list of packages:
1. "Better-DDE"
2. "Vivaldi"
3. "Thunderbird"
4. "Motrix"
5. "Spark-Store"
6. "YesPlayMusic"
7. "Zotero"
8. "Calibre"
9. "Joplin"
10. "VSCode"
11. "WPS-CN"
12. "Shadowsocks-Electron"
13. "rclone"
14. "PulseAudio"
15. "Eudic"
16. "Zoom"
17. "Vulkan"
18. "Steam"
19. "Heroic Game Launcher"

## following packages are installed by default

- whiptail
- gdebi
- aria2
- git
- fonts-noto-color-emoji

## setup rclone mount as disk

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

### Deprecated

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
