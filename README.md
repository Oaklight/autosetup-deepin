# autosetup
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
15. "Vulkan"
16. "Steam"
17. "Heroic Game Launcher"
18. "Eudic"
19. "Zoom"

## setup rclone mount as disk
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
