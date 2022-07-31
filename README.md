# autosetup
autosetup script to ease my reinstallment :)

## setup rclone mount as disk
cp rclone-* ~/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable --now rclone-onedrive-personal.service
systemctl --user enable --now rclone-onedrive-uchicago.service
systemctl --user enable --now rclone-megasync.service
