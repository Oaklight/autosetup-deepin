# 自动设置

[English](./README_EN.md)

一个简单的自动设置脚本，以方便我重新安装和新系统的设置 :)

目前的软件包列表。
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

## 自定义图表主题

`tar -xf ./themes/icons/<icon-theme>.tar.xz -C ~/.local/share/icons`

## obsolete

- 移除better-dde，因为目前其安装方式基本等于没有办法卸载，所以不再默认支持。如需要请自行搜索安装或使用历史版本的该脚本。

## 默认安装以下软件包

- whiptail
- gdebi
- aria2
- git
- fonts-noto-color-emoji

## 设置 rclone 挂载为磁盘

### 推荐

本维基百科介绍了一种创建rclone服务的模板方式：https://github.com/rclone/rclone/wiki/Systemd-rclone-mount

`rclone@.service`文件是systemd的模板服务文件。
> 如果你希望整个系统都能访问上述文件，可将其保存为`/etc/systemd/user/rclone@.service`，或者`~/.config/systemd/user/rclone@.service`。

该脚本将文件放在`~/.config/systemd/user/rclone@.service`处。

运行`systemctl --user daemon-reload`来刷新systemd服务列表

#### 基本配置

```bash
# 假设我们已经在rclone中配置了 "OneDrive-Personal"。
# 创建本地映射目录
mkdir -p ~/OneDrive-Personal
systemctl --user start rclone@OneDrive-Personal

# 检查 ~/OneDrive-Personal，如果能看到网盘文件则进行下一步
# 设置rclone服务自动启动
systemctl --user enable rclone@OneDrive-Personal
```

### 废弃的

```bash
# 创建本地映射目录
mkdir -p ~/OneDrive-Personal
mkdir -p ~/OneDrive-UChicago
mkdir -p ~/MegaSync
# 设置 systemd 服务，参考：https://www.guyrutenberg.com/2021/06/25/autostart-rclone-mount-using-systemd/
cp rclone-* ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable -- now rclone-onedrive-personal.service
systemctl --user enable -- now rclone-onedrive-uchicago.service
systemctl --user enable -- now rclone-megasync.service
```
